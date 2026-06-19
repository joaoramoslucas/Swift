import SwiftUI

enum OrderStatus: Int, CaseIterable {
    case confirmed = 0
    case preparing = 1
    case onTheWay = 2
    case delivered = 3

    var title: String {
        switch self {
        case .confirmed: return "Pedido Confirmado"
        case .preparing: return "Preparando"
        case .onTheWay: return "A caminho"
        case .delivered: return "Entregue"
        }
    }

    var subtitle: String {
        switch self {
        case .confirmed: return "Seu pedido foi recebido pelo restaurante"
        case .preparing: return "O restaurante está preparando seu pedido"
        case .onTheWay: return "Entregador a caminho do seu endereço"
        case .delivered: return "Pedido entregue! Bom apetite!"
        }
    }

    var icon: String {
        switch self {
        case .confirmed: return "checkmark.circle.fill"
        case .preparing: return "frying.pan.fill"
        case .onTheWay: return "bicycle"
        case .delivered: return "bag.fill"
        }
    }

    var estimatedTime: String {
        switch self {
        case .confirmed: return "~35 min"
        case .preparing: return "~25 min"
        case .onTheWay: return "~10 min"
        case .delivered: return "Chegou!"
        }
    }
}

struct OrderTrackingView: View {
    @StateObject private var viewModel = OrderTrackingViewModel()
    @Environment(\.dismiss) var dismiss
    let orderTotal: Double
    let paymentMethod: PaymentMethod
    let deliveryAddress: String

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    // Animated Header
                    orderStatusHeader

                    // Live Tracking Progress
                    trackingTimeline

                    // Order Info Card
                    orderInfoCard

                    // Delivery Map Placeholder
                    deliveryMapPlaceholder

                    // Help Button
                    Button {
                        // Help action
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "questionmark.circle")
                            Text("Precisa de ajuda?")
                        }
                        .font(.subheadline)
                        .foregroundColor(.orange)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.08))
                        .cornerRadius(12)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Acompanhar Pedido")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Text("Fechar")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .onAppear {
            viewModel.startTracking()
        }
        .interactiveDismissDisabled(viewModel.currentStatus != .delivered)
    }

    // MARK: - Status Header
    private var orderStatusHeader: some View {
        VStack(spacing: 16) {
            // Animated Icon
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .scaleEffect(viewModel.pulseAnimation ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: viewModel.pulseAnimation)

                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 76, height: 76)

                Image(systemName: viewModel.currentStatus.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.orange)
            }

            VStack(spacing: 6) {
                Text(viewModel.currentStatus.title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(viewModel.currentStatus.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // ETA
            if viewModel.currentStatus != .delivered {
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text("Previsão: \(viewModel.currentStatus.estimatedTime)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(20)
            }
        }
    }

    // MARK: - Timeline
    private var trackingTimeline: some View {
        VStack(spacing: 0) {
            ForEach(OrderStatus.allCases, id: \.rawValue) { status in
                HStack(alignment: .top, spacing: 16) {
                    // Timeline indicator
                    VStack(spacing: 0) {
                        Circle()
                            .fill(status.rawValue <= viewModel.currentStatus.rawValue ? Color.orange : Color.gray.opacity(0.3))
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 6, height: 6)
                                    .opacity(status.rawValue <= viewModel.currentStatus.rawValue ? 1 : 0)
                            )

                        if status != .delivered {
                            Rectangle()
                                .fill(status.rawValue < viewModel.currentStatus.rawValue ? Color.orange : Color.gray.opacity(0.2))
                                .frame(width: 2, height: 44)
                        }
                    }

                    // Content
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(status.title)
                                .font(.subheadline)
                                .fontWeight(status == viewModel.currentStatus ? .bold : .regular)
                                .foregroundColor(status.rawValue <= viewModel.currentStatus.rawValue ? .primary : .secondary)

                            Spacer()

                            if status.rawValue < viewModel.currentStatus.rawValue {
                                Image(systemName: "checkmark")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                            } else if status == viewModel.currentStatus && status != .delivered {
                                ProgressView()
                                    .scaleEffect(0.7)
                            }
                        }

                        if status == viewModel.currentStatus {
                            Text(status.subtitle)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        if let time = viewModel.completedTimes[status.rawValue] {
                            Text(time)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, status != .delivered ? 20 : 0)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    // MARK: - Order Info
    private var orderInfoCard: some View {
        VStack(spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.orange)
                Text("Detalhes do Pedido")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Spacer()
            }

            Divider()

            infoRow(icon: "mappin", label: "Endereço", value: deliveryAddress)
            infoRow(icon: paymentMethod.icon, label: "Pagamento", value: paymentMethod.rawValue)
            infoRow(icon: "dollarsign.circle", label: "Total", value: orderTotal.formatted(.currency(code: "BRL")))
            infoRow(icon: "number", label: "Pedido", value: "#\(viewModel.orderNumber)")
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.gray)
                .frame(width: 18)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }

    // MARK: - Map Placeholder
    private var deliveryMapPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 160)

            VStack(spacing: 10) {
                Image(systemName: "map.fill")
                    .font(.title)
                    .foregroundColor(.orange.opacity(0.6))

                if viewModel.currentStatus == .onTheWay {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("Entregador próximo a você")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .transition(.opacity)
                } else {
                    Text("Mapa de acompanhamento")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
