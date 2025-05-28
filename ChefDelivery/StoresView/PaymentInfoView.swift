import SwiftUI

struct PaymentInfoView: View {
    @ObservedObject var checkoutViewModel: CheckoutViewModel
    @Binding var path: NavigationPath
    @FocusState private var focusedField: Field?
    @State private var saveCard: Bool = false
    @State private var isFlipped = false

    enum Field {
        case name, card, expiration, cvv
    }

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            ZStack {
                // Frente do cartão
                cardFront
                    .opacity(isFlipped ? 0.0 : 1.0)
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x:0, y:1, z:0))

                // Verso do cartão (CVV)
                cardBack
                    .opacity(isFlipped ? 1.0 : 0.0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x:0, y:1, z:0))
            }
            .frame(width: 320, height: 200)
            .animation(.easeInOut(duration: 0.6), value: isFlipped)
            .onChange(of: focusedField) { newField in
                withAnimation {
                    isFlipped = (newField == .cvv)
                }
            }

            // Campos de texto
            formFields
                .padding(.horizontal)

            // Botão Salvar Cartão
            Button(action: {
                saveCard.toggle()
                // Aqui você pode adicionar sua lógica de salvar o cartão, ex:
                // checkoutViewModel.saveCard()
            }) {
                HStack {
                    Image(systemName: saveCard ? "checkmark.circle.fill" : "creditcard")
                    Text(saveCard ? "Cartão Salvo" : "Salvar Cartão")
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(saveCard ? Color.green : Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding(.horizontal)

            Spacer()

            Button("Finalizar Pedido") {
                checkoutViewModel.confirmOrder()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding(.horizontal)
        }
        .alert("Pedido Confirmado", isPresented: $checkoutViewModel.isOrderConfirmed) {
            Button("OK", role: .cancel) {
                path = NavigationPath() // reinicia o fluxo
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Cartão frente
    private var cardFront: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(radius: 8)

            VStack(alignment: .leading, spacing: 16) {
                Text("Nome")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(checkoutViewModel.name.isEmpty ? "" : checkoutViewModel.name)
                    .font(.title2)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Spacer()

                Text("Número do Cartão")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(formattedCardNumber)
                    .font(.title2)
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .lineLimit(1)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Validade")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(checkoutViewModel.expirationDate.isEmpty ? "MM/AA" : checkoutViewModel.expirationDate)
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
            .padding(20)
        }
    }
    
    // MARK: - Cartão verso
    private var cardBack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(radius: 8)

            VStack(spacing: 20) {
                Rectangle()
                    .fill(Color.black.opacity(0.85))
                    .frame(height: 40)
                    .cornerRadius(5)
                    .padding(.horizontal, 20)

                Spacer()

                HStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CVV")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(checkoutViewModel.cvv.isEmpty ? "***" : checkoutViewModel.cvv)
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(6)
                    }
                    .padding(.trailing, 30)
                }
                Spacer()
            }
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Campos de formulário
    private var formFields: some View {
        VStack(spacing: 16) {
            TextField("Nome no cartão", text: Binding(
                get: { checkoutViewModel.name },
                set: { checkoutViewModel.updateName($0) }
            ))
            .textFieldStyle(.roundedBorder)
            .focused($focusedField, equals: .name)

            TextField("Número do cartão", text: Binding(
                get: { checkoutViewModel.cardNumber },
                set: { checkoutViewModel.updateCardNumber($0) }
            ))
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)
            .focused($focusedField, equals: .card)

            TextField("Validade (MM/AA)", text: Binding(
                get: { checkoutViewModel.expirationDate },
                set: { checkoutViewModel.updateExpirationDate($0) }
            ))
            .keyboardType(.numbersAndPunctuation)
            .textFieldStyle(.roundedBorder)
            .focused($focusedField, equals: .expiration)

            TextField("CVV", text: Binding(
                get: { checkoutViewModel.cvv },
                set: { checkoutViewModel.updateCVV($0) }
            ))
            .keyboardType(.numberPad)
            .textFieldStyle(.roundedBorder)
            .focused($focusedField, equals: .cvv)
        }
    }

    // MARK: - Formata o número do cartão (ex: 1234 5678 9012 3456)
    private var formattedCardNumber: String {
        let trimmed = checkoutViewModel.cardNumber.filter { $0.isNumber }
        var result = ""
        for (index, digit) in trimmed.enumerated() {
            if index != 0 && index % 4 == 0 {
                result += " "
            }
            result.append(digit)
        }
        return result.isEmpty ? "•••• •••• •••• ••••" : result
    }
}
