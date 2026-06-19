import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @StateObject private var viewModel = CheckoutViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showTracking: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Indicator
                CheckoutProgressBar(currentStep: viewModel.currentStep)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                // Content
                TabView(selection: $viewModel.currentStep) {
                    DeliveryInfoView(viewModel: viewModel)
                        .tag(0)

                    PaymentInfoView(viewModel: viewModel)
                        .tag(1)

                    OrderReviewView(viewModel: viewModel)
                        .environmentObject(cartViewModel)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)

                // Bottom Navigation
                checkoutBottomBar
            }
            .navigationTitle(stepTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onChange(of: viewModel.isOrderConfirmed) { confirmed in
                if confirmed {
                    showTracking = true
                }
            }
            .fullScreenCover(isPresented: $showTracking) {
                OrderTrackingView(
                    orderTotal: calculateTotal(),
                    paymentMethod: viewModel.selectedPayment,
                    deliveryAddress: viewModel.address
                )
            }
        }
    }

    private var stepTitle: String {
        switch viewModel.currentStep {
        case 0: return "Entrega"
        case 1: return "Pagamento"
        case 2: return "Revisão"
        default: return "Checkout"
        }
    }

    private var checkoutBottomBar: some View {
        VStack(spacing: 12) {
            Divider()

            // Security badge
            if viewModel.currentStep == 1 {
                HStack(spacing: 6) {
                    Image(systemName: "lock.shield.fill")
                        .font(.caption2)
                        .foregroundColor(.green)
                    Text("Pagamento seguro com criptografia")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            HStack(spacing: 12) {
                if viewModel.currentStep > 0 {
                    Button {
                        withAnimation { viewModel.currentStep -= 1 }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Voltar")
                        }
                        .font(.subheadline).fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.secondarySystemBackground))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                }

                Button {
                    if viewModel.currentStep < 2 {
                        withAnimation { viewModel.currentStep += 1 }
                    } else {
                        viewModel.confirmOrder()
                    }
                } label: {
                    HStack {
                        if viewModel.isProcessing {
                            ProgressView().tint(.white)
                        } else {
                            Text(viewModel.currentStep == 2 ? "Confirmar Pedido" : "Próximo")
                            Image(systemName: viewModel.currentStep == 2 ? "checkmark" : "chevron.right")
                        }
                    }
                    .font(.subheadline).fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(nextButtonEnabled ? Color.orange : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!nextButtonEnabled || viewModel.isProcessing)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
    }

    private var nextButtonEnabled: Bool {
        switch viewModel.currentStep {
        case 0: return viewModel.isDeliveryValid
        case 1: return viewModel.isPaymentValid
        case 2: return true
        default: return false
        }
    }

    private func calculateTotal() -> Double {
        let subtotal = cartViewModel.totalPrice
        let deliveryFee: Double = subtotal >= 50 ? 0 : 5.99
        var total = subtotal + deliveryFee
        if viewModel.selectedPayment == .pix {
            total -= subtotal * 0.05
        }
        return total
    }
}

// MARK: - Progress Bar
struct CheckoutProgressBar: View {
    let currentStep: Int
    let steps = ["Entrega", "Pagamento", "Revisão"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { index in
                HStack(spacing: 6) {
                    Circle()
                        .fill(index <= currentStep ? Color.orange : Color.gray.opacity(0.3))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Group {
                                if index < currentStep {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(index <= currentStep ? .white : .gray)
                                }
                            }
                        )

                    Text(steps[index])
                        .font(.caption2)
                        .fontWeight(index == currentStep ? .bold : .regular)
                        .foregroundColor(index <= currentStep ? .primary : .secondary)
                }

                if index < steps.count - 1 {
                    Rectangle()
                        .fill(index < currentStep ? Color.orange : Color.gray.opacity(0.3))
                        .frame(height: 2)
                }
            }
        }
        .padding(.vertical, 14)
    }
}
