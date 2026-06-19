import SwiftUI

struct PaymentInfoView: View {
    @ObservedObject var viewModel: CheckoutViewModel
    @FocusState private var focusedField: PaymentField?
    @State private var isFlipped: Bool = false

    enum PaymentField {
        case holder, number, expiration, cvv
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Como deseja pagar?")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Escolha sua forma de pagamento preferida")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Payment Method Selector
                VStack(spacing: 10) {
                    ForEach(PaymentMethod.allCases) { method in
                        PaymentMethodRow(
                            method: method,
                            isSelected: viewModel.selectedPayment == method
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.selectedPayment = method
                            }
                        }
                    }
                }

                // Payment Details Based on Selection
                switch viewModel.selectedPayment {
                case .creditCard, .debitCard:
                    cardPaymentSection
                case .pix:
                    pixPaymentSection
                case .cash:
                    cashPaymentSection
                }
            }
            .padding(20)
        }
        .onChange(of: focusedField) { newField in
            withAnimation(.easeInOut(duration: 0.5)) {
                isFlipped = (newField == .cvv)
            }
        }
    }

    // MARK: - Card Payment
    private var cardPaymentSection: some View {
        VStack(spacing: 20) {
            // Card Preview
            ZStack {
                cardFrontView
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

                cardBackView
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
            }
            .frame(height: 190)
            .animation(.easeInOut(duration: 0.5), value: isFlipped)

            // Card Form
            VStack(spacing: 14) {
                CheckoutFormField(
                    icon: "person.text.rectangle",
                    title: "Nome no cartão",
                    placeholder: "NOME COMO ESTÁ NO CARTÃO",
                    text: Binding(
                        get: { viewModel.cardHolder },
                        set: { viewModel.updateCardHolder($0) }
                    )
                )
                .focused($focusedField, equals: .holder)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Número do cartão")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    HStack(spacing: 12) {
                        Image(systemName: "creditcard")
                            .foregroundColor(.orange)
                            .frame(width: 20)
                        TextField("0000 0000 0000 0000", text: Binding(
                            get: { viewModel.cardNumber },
                            set: { viewModel.updateCardNumber($0) }
                        ))
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .number)

                        if viewModel.detectedCardBrand != .unknown {
                            Text(viewModel.detectedCardBrand.name)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                                .transition(.opacity)
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(viewModel.cardValidationError != nil ? Color.red.opacity(0.5) : Color.clear, lineWidth: 1)
                    )

                    if let error = viewModel.cardValidationError {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption2)
                            Text(error)
                                .font(.caption2)
                        }
                        .foregroundColor(.red)
                        .transition(.opacity)
                    }
                }

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Validade")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .foregroundColor(.orange)
                                .frame(width: 20)
                            TextField("MM/AA", text: Binding(
                                get: { viewModel.expirationDate },
                                set: { viewModel.updateExpirationDate($0) }
                            ))
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .expiration)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("CVV")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)

                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.orange)
                                .frame(width: 20)
                            SecureField("•••", text: Binding(
                                get: { viewModel.cvv },
                                set: { viewModel.updateCVV($0) }
                            ))
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .cvv)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
            }

            // Save Card Toggle
            Button {
                viewModel.saveCard()
            } label: {
                HStack {
                    Image(systemName: viewModel.isCardSaved ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(viewModel.isCardSaved ? .green : .gray)
                    Text(viewModel.isCardSaved ? "Cartão salvo com segurança" : "Salvar cartão para próximas compras")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "lock.shield.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding(14)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Card Front
    private var cardFrontView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.1, green: 0.1, blue: 0.3), Color(red: 0.3, green: 0.1, blue: 0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("ChefDelivery")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Image(systemName: viewModel.selectedPayment == .debitCard ? "wave.3.right" : "creditcard.fill")
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Text(viewModel.formattedCardNumber)
                    .font(.system(size: 20, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .tracking(2)

                Spacer()

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TITULAR")
                            .font(.system(size: 9))
                            .foregroundColor(.white.opacity(0.6))
                        Text(viewModel.cardHolder.isEmpty ? "SEU NOME" : viewModel.cardHolder)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("VALIDADE")
                            .font(.system(size: 9))
                            .foregroundColor(.white.opacity(0.6))
                        Text(viewModel.expirationDate.isEmpty ? "MM/AA" : viewModel.expirationDate)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(20)
        }
    }

    // MARK: - Card Back
    private var cardBackView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.3, green: 0.1, blue: 0.5), Color(red: 0.1, green: 0.1, blue: 0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

            VStack(spacing: 20) {
                Rectangle()
                    .fill(Color.black.opacity(0.8))
                    .frame(height: 44)
                    .padding(.top, 20)

                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Text("CVV")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))
                        Text(viewModel.cvv.isEmpty ? "•••" : viewModel.cvv)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(6)
                    }
                    .padding(.trailing, 30)
                }

                Spacer()
            }
        }
    }

    // MARK: - PIX Section
    private var pixPaymentSection: some View {
        VStack(spacing: 20) {
            // PIX Info Card
            VStack(spacing: 16) {
                Image(systemName: "qrcode")
                    .font(.system(size: 60))
                    .foregroundColor(.green)

                Text("Pagamento via PIX")
                    .font(.headline)

                Text("Ao confirmar o pedido, você receberá um QR Code e a chave PIX para realizar o pagamento.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.orange)
                    Text("Aprovação instantânea")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)

            // Benefits
            VStack(alignment: .leading, spacing: 12) {
                pixBenefit(icon: "percent", text: "5% de desconto no pagamento via PIX")
                pixBenefit(icon: "clock.fill", text: "Confirmação em segundos")
                pixBenefit(icon: "shield.checkered", text: "Pagamento seguro e protegido")
            }
        }
    }

    private func pixBenefit(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.green)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Cash Section
    private var cashPaymentSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Image(systemName: "banknote")
                    .font(.system(size: 50))
                    .foregroundColor(.green)

                Text("Pagamento em Dinheiro")
                    .font(.headline)

                Text("Pague ao entregador no momento da entrega.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)

            // Change field
            VStack(alignment: .leading, spacing: 6) {
                Text("Precisa de troco para quanto?")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                HStack(spacing: 12) {
                    Image(systemName: "brazilianrealsign.circle")
                        .foregroundColor(.orange)
                        .frame(width: 20)
                    TextField("Ex: 50,00 (deixe vazio se não precisa)", text: $viewModel.cashChange)
                        .keyboardType(.decimalPad)
                }
                .padding(14)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Payment Method Row
struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: method.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .orange : .gray)
                    .frame(width: 28)

                Text(method.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .orange : .gray.opacity(0.4))
            }
            .padding(14)
            .background(isSelected ? Color.orange.opacity(0.08) : Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.orange.opacity(0.5) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}
