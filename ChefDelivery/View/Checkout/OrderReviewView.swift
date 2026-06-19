import SwiftUI

struct OrderReviewView: View {
    @ObservedObject var viewModel: CheckoutViewModel
    @EnvironmentObject var cartViewModel: CartViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Revise seu pedido")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Confira se está tudo certo antes de confirmar")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Delivery Info Card
                ReviewSectionCard(title: "Entrega", icon: "mappin.circle.fill") {
                    VStack(alignment: .leading, spacing: 8) {
                        ReviewInfoRow(label: "Nome", value: viewModel.name)
                        ReviewInfoRow(label: "Telefone", value: viewModel.formattedPhone)
                        ReviewInfoRow(label: "Endereço", value: viewModel.address)
                        if !viewModel.complement.isEmpty {
                            ReviewInfoRow(label: "Complemento", value: viewModel.complement)
                        }
                    }
                }

                // Payment Info Card
                ReviewSectionCard(title: "Pagamento", icon: "creditcard.fill") {
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.selectedPayment.icon)
                            .font(.title3)
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(viewModel.selectedPayment.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            if viewModel.selectedPayment == .creditCard || viewModel.selectedPayment == .debitCard {
                                Text("•••• •••• •••• \(String(viewModel.cardNumber.suffix(4)))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                }

                // Order Items
                ReviewSectionCard(title: "Itens (\(cartViewModel.items.count))", icon: "bag.fill") {
                    VStack(spacing: 12) {
                        ForEach(cartViewModel.items.indices, id: \.self) { index in
                            let item = cartViewModel.items[index]
                            HStack(spacing: 12) {
                                RemoteImage(
                                    url: item.product.image,
                                    placeholder: "fork.knife",
                                    width: 44,
                                    height: 44,
                                    cornerRadius: 8
                                )

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.product.name)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                    Text("x\(item.quantity)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text(item.subTotal, format: .currency(code: "BRL"))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }

                            if index < cartViewModel.items.count - 1 {
                                Divider()
                            }
                        }
                    }
                }

                // Total Summary
                VStack(spacing: 10) {
                    Divider()

                    HStack {
                        Text("Subtotal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(cartViewModel.totalPrice, format: .currency(code: "BRL"))
                            .font(.subheadline)
                    }

                    HStack {
                        Text("Taxa de entrega")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(deliveryFee, format: .currency(code: "BRL"))
                            .font(.subheadline)
                            .foregroundColor(deliveryFee == 0 ? .green : .primary)
                    }

                    if viewModel.selectedPayment == .pix {
                        HStack {
                            Text("Desconto PIX (5%)")
                                .font(.subheadline)
                                .foregroundColor(.green)
                            Spacer()
                            Text(-(cartViewModel.totalPrice * 0.05), format: .currency(code: "BRL"))
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }

                    Divider()

                    HStack {
                        Text("Total")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        Text(totalWithExtras, format: .currency(code: "BRL"))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(14)
            }
            .padding(20)
        }
    }

    private var deliveryFee: Double {
        cartViewModel.totalPrice >= 50 ? 0 : 5.99
    }

    private var totalWithExtras: Double {
        var total = cartViewModel.totalPrice + deliveryFee
        if viewModel.selectedPayment == .pix {
            total -= cartViewModel.totalPrice * 0.05
        }
        return total
    }
}

// MARK: - Review Section Card
struct ReviewSectionCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.orange)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }

            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}

// MARK: - Review Info Row
struct ReviewInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 90, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}
