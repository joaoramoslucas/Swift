import Foundation
import Combine

class CheckoutViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var cardNumber: String = ""
    @Published var expirationDate: String = ""
    @Published var cvv: String = ""
    @Published var address: String = ""
    @Published var isOrderConfirmed: Bool = false
    
    @Published var isCardSaved: Bool = false
    
    private let cardStorageKey = "savedCardInfo"

    func updateName(_ newValue: String) {
        var filtered = newValue.filter { $0.isLetter || $0.isWhitespace || $0 == "-" || $0 == "'" }
        if filtered.count > 30 { filtered = String(filtered.prefix(30)) }
        name = filtered
    }

    func updateCardNumber(_ newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        cardNumber = String(filtered.prefix(16))
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

    func updateAddress(_ newValue: String) {
        address = String(newValue.prefix(100))
    }

    func confirmOrder() {
        isOrderConfirmed = true
    }
    
    func saveCard() {
        let cardInfo: [String: String] = [
            "name": name,
            "cardNumber": cardNumber,
            "expirationDate": expirationDate,
            "cvv": cvv
        ]
        if let data = try? JSONSerialization.data(withJSONObject: cardInfo, options: []) {
            UserDefaults.standard.set(data, forKey: cardStorageKey)
            isCardSaved = true
        }
    }
    
    func loadSavedCard() {
        guard let data = UserDefaults.standard.data(forKey: cardStorageKey),
              let cardInfo = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        else { return }
        name = cardInfo["name"] ?? ""; cardNumber = cardInfo["cardNumber"] ?? ""
        expirationDate = cardInfo["expirationDate"] ?? ""; cvv = cardInfo["cvv"] ?? ""
        isCardSaved = true
    }
}
