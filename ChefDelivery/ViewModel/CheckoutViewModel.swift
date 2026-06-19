import Foundation
import Combine

enum PaymentMethod: String, CaseIterable, Identifiable {
    case creditCard = "Cartão de Crédito"
    case debitCard = "Cartão de Débito"
    case pix = "PIX"
    case cash = "Dinheiro"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .creditCard: return "creditcard.fill"
        case .debitCard: return "creditcard"
        case .pix: return "qrcode"
        case .cash: return "banknote"
        }
    }
}

enum CardBrand {
    case visa, mastercard, amex, elo, unknown

    var name: String {
        switch self {
        case .visa: return "Visa"
        case .mastercard: return "Mastercard"
        case .amex: return "Amex"
        case .elo: return "Elo"
        case .unknown: return ""
        }
    }

    var icon: String {
        switch self {
        case .visa: return "v.square.fill"
        case .mastercard: return "m.square.fill"
        case .amex: return "a.square.fill"
        case .elo: return "e.square.fill"
        case .unknown: return "creditcard"
        }
    }
}

class CheckoutViewModel: ObservableObject {
    // Delivery Info
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var complement: String = ""
    @Published var phone: String = ""

    // Payment Info
    @Published var selectedPayment: PaymentMethod = .creditCard
    @Published var cardNumber: String = ""
    @Published var cardHolder: String = ""
    @Published var expirationDate: String = ""
    @Published var cvv: String = ""
    @Published var cashChange: String = ""

    // State
    @Published var isOrderConfirmed: Bool = false
    @Published var isCardSaved: Bool = false
    @Published var isProcessing: Bool = false
    @Published var currentStep: Int = 0
    @Published var cardValidationError: String? = nil

    private let secureStorage: SecureStorageProtocol
    private let cardStorageKey = "savedCard"

    init(secureStorage: SecureStorageProtocol = KeychainService.shared) {
        self.secureStorage = secureStorage
    }

    // MARK: - Card Brand Detection
    var detectedCardBrand: CardBrand {
        let digits = cardNumber.filter { $0.isNumber }
        guard !digits.isEmpty else { return .unknown }

        if digits.hasPrefix("4") { return .visa }
        if digits.hasPrefix("5") || digits.hasPrefix("2") { return .mastercard }
        if digits.hasPrefix("34") || digits.hasPrefix("37") { return .amex }
        if digits.hasPrefix("636") || digits.hasPrefix("438") || digits.hasPrefix("504") { return .elo }
        return .unknown
    }

    // MARK: - Validation
    var isDeliveryValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !address.trimmingCharacters(in: .whitespaces).isEmpty &&
        phone.filter({ $0.isNumber }).count >= 10
    }

    var isPaymentValid: Bool {
        switch selectedPayment {
        case .creditCard, .debitCard:
            return isCardValid
        case .pix, .cash:
            return true
        }
    }

    var isCardValid: Bool {
        let validNumber = cardNumber.count == 16 && luhnCheck(cardNumber)
        let validHolder = !cardHolder.trimmingCharacters(in: .whitespaces).isEmpty
        let validExpiry = isExpirationValid
        let validCVV = cvv.count == 3
        return validNumber && validHolder && validExpiry && validCVV
    }

    var isExpirationValid: Bool {
        guard expirationDate.count == 5 else { return false }
        let parts = expirationDate.split(separator: "/")
        guard parts.count == 2,
              let month = Int(parts[0]),
              let year = Int(parts[1]) else { return false }

        guard month >= 1 && month <= 12 else { return false }

        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date()) % 100
        let currentMonth = calendar.component(.month, from: Date())

        if year < currentYear { return false }
        if year == currentYear && month < currentMonth { return false }
        return true
    }

    // MARK: - Luhn Algorithm (card number validation)
    private func luhnCheck(_ number: String) -> Bool {
        let digits = number.compactMap { $0.wholeNumberValue }
        guard digits.count >= 13 else { return false }

        var sum = 0
        let reversedDigits = digits.reversed().enumerated()

        for (index, digit) in reversedDigits {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }

    // MARK: - Input Formatters
    func updateName(_ newValue: String) {
        var filtered = newValue.filter { $0.isLetter || $0.isWhitespace || $0 == "-" || $0 == "'" }
        if filtered.count > 40 { filtered = String(filtered.prefix(40)) }
        name = filtered
    }

    func updateCardHolder(_ newValue: String) {
        var filtered = newValue.uppercased().filter { $0.isLetter || $0.isWhitespace }
        if filtered.count > 30 { filtered = String(filtered.prefix(30)) }
        cardHolder = filtered
    }

    func updateCardNumber(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        cardNumber = String(filtered.prefix(16))
        cardValidationError = nil
    }

    func updateExpirationDate(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        var result = ""
        for (index, char) in filtered.prefix(4).enumerated() {
            if index == 2 { result += "/" }
            result.append(char)
        }
        expirationDate = result
    }

    func updateCVV(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        cvv = String(filtered.prefix(3))
    }

    func updatePhone(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        phone = String(filtered.prefix(11))
    }

    func updateAddress(_ newValue: String) {
        address = String(newValue.prefix(100))
    }

    var formattedCardNumber: String {
        let trimmed = cardNumber.filter { $0.isNumber }
        var result = ""
        for (index, digit) in trimmed.enumerated() {
            if index != 0 && index % 4 == 0 { result += " " }
            result.append(digit)
        }
        return result.isEmpty ? "•••• •••• •••• ••••" : result
    }

    // Masked version for display (security)
    var maskedCardNumber: String {
        guard cardNumber.count >= 4 else { return "•••• •••• •••• ••••" }
        let lastFour = String(cardNumber.suffix(4))
        return "•••• •••• •••• \(lastFour)"
    }

    var formattedPhone: String {
        let digits = phone.filter { $0.isNumber }
        if digits.count >= 10 {
            let area = digits.prefix(2)
            let hasNine = digits.count == 11
            let part1 = hasNine ? digits.dropFirst(2).prefix(5) : digits.dropFirst(2).prefix(4)
            let part2 = hasNine ? digits.suffix(4) : digits.suffix(4)
            return "(\(area)) \(part1)-\(part2)"
        }
        return phone
    }

    // MARK: - Actions
    func validateCardBeforeProceeding() -> Bool {
        if selectedPayment == .creditCard || selectedPayment == .debitCard {
            if cardNumber.count == 16 && !luhnCheck(cardNumber) {
                cardValidationError = "Número do cartão inválido"
                return false
            }
            if !isExpirationValid && expirationDate.count == 5 {
                cardValidationError = "Cartão expirado ou data inválida"
                return false
            }
        }
        cardValidationError = nil
        return true
    }

    func confirmOrder() {
        guard validateCardBeforeProceeding() else { return }
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isProcessing = false
            self?.isOrderConfirmed = true
        }
    }

    // MARK: - Secure Card Storage
    func saveCard() {
        let cardData = "\(cardHolder)|\(cardNumber)|\(expirationDate)"
        guard let data = cardData.data(using: .utf8) else { return }
        isCardSaved = secureStorage.save(key: cardStorageKey, data: data)
    }

    func loadSavedCard() {
        guard let data = secureStorage.load(key: cardStorageKey),
              let cardString = String(data: data, encoding: .utf8) else { return }

        let parts = cardString.split(separator: "|")
        guard parts.count == 3 else { return }
        cardHolder = String(parts[0])
        cardNumber = String(parts[1])
        expirationDate = String(parts[2])
        isCardSaved = true
    }

    func reset() {
        name = ""; address = ""; complement = ""; phone = ""
        cardNumber = ""; cardHolder = ""; expirationDate = ""; cvv = ""
        cashChange = ""; currentStep = 0; isOrderConfirmed = false
        selectedPayment = .creditCard; cardValidationError = nil
    }
}
