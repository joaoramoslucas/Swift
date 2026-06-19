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

    @State private var showRating: Bool = false
    @State private var selectedRating: Int = 0

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    orderStatusHeader
                    trackingTimeline
                    orderInfoCard
                    deliveryMapPlaceholder

                    Button {} label: {
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
                    if viewModel.currentStatus == .delivered {
                        Button { dismiss() } label: {
                            Text("Fechar")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.startTracking()
        }
        .interactiveDismissDisabled(true)
        .onChange(of: viewModel.currentStatus) { status in
            if status == .delivered {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showRating = true
                }
            }
        }
        .sheet(isPresented: $showRating) {
            RatingView(selectedRating: $selectedRating) {
                showRating = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    NotificationCenter.default.post(name: .orderCompleted, object: nil)
                }
            }
            .presentationDetents([.medium])
            .interactiveDismissDisabled(true)
        }
    }

    // MARK: - Status Header
    private var orderStatusHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                if viewModel.isPulsing {
                    Circle()
                        .fill(Color.orange.opacity(0.12))
                        .frame(width: 90, height: 90)
                        .scaleEffect(viewModel.isPulsing ? 1.2 : 1.0)
                        .opacity(viewModel.isPulsing ? 0.4 : 0.8)
                        .animation(
                            .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                            value: viewModel.isPulsing
                        )
                }

                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 80, height: 80)

                Image(systemName: viewModel.currentStatus.icon)
                    .font(.system(size: 36))
                    .foregroundColor(.orange)
            }
            .frame(width: 110, height: 110)

            VStack(spacing: 6) {
                Text(viewModel.currentStatus.title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(viewModel.currentStatus.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

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
                } else {
                    Text("Mapa de acompanhamento")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Rating View
struct RatingView: View {
    @Binding var selectedRating: Int
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "star.bubble.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.orange)

                Text("Como foi sua experiência?")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Avalie a loja para ajudar outros clientes")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)

            // Stars
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= selectedRating ? "star.fill" : "star")
                        .font(.system(size: 36))
                        .foregroundColor(star <= selectedRating ? .orange : .gray.opacity(0.3))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedRating = star
                            }
                        }
                }
            }

            if selectedRating > 0 {
                Text(ratingText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onConfirm) {
                Text(selectedRating > 0 ? "Enviar Avaliação" : "Pular")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(selectedRating > 0 ? Color.orange : Color(.secondarySystemBackground))
                    .foregroundColor(selectedRating > 0 ? .white : .primary)
                    .cornerRadius(14)
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 24)
    }

    private var ratingText: String {
        switch selectedRating {
        case 1: return "Péssimo 😞"
        case 2: return "Ruim 😕"
        case 3: return "Regular 😐"
        case 4: return "Bom 😊"
        case 5: return "Excelente! 🤩"
        default: return ""
        }
    }
}
