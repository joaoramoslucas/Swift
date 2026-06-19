import SwiftUI

struct DeliveryInfoView: View {
    @ObservedObject var viewModel: CheckoutViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Para onde entregar?")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Preencha os dados de entrega do seu pedido")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Form
                VStack(spacing: 16) {
                    CheckoutFormField(
                        icon: "person.fill",
                        title: "Nome completo",
                        placeholder: "Seu nome",
                        text: Binding(
                            get: { viewModel.name },
                            set: { viewModel.updateName($0) }
                        )
                    )

                    CheckoutFormField(
                        icon: "phone.fill",
                        title: "Telefone",
                        placeholder: "11999999999",
                        text: Binding(
                            get: { viewModel.phone },
                            set: { viewModel.updatePhone($0) }
                        ),
                        keyboard: .phonePad
                    )

                    CheckoutFormField(
                        icon: "mappin.circle.fill",
                        title: "Endereço",
                        placeholder: "Rua, número, bairro",
                        text: Binding(
                            get: { viewModel.address },
                            set: { viewModel.updateAddress($0) }
                        )
                    )

                    CheckoutFormField(
                        icon: "building.2.fill",
                        title: "Complemento (opcional)",
                        placeholder: "Apto, bloco, referência",
                        text: $viewModel.complement
                    )
                }

                // Delivery Time Estimate
                HStack(spacing: 12) {
                    Image(systemName: "clock.fill")
                        .font(.title3)
                        .foregroundColor(.orange)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tempo estimado")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("30 - 45 min")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }

                    Spacer()

                    Image(systemName: "bicycle")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                .padding()
                .background(Color.orange.opacity(0.08))
                .cornerRadius(12)
            }
            .padding(20)
        }
    }
}

// MARK: - Form Field
struct CheckoutFormField: View {
    let icon: String
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.orange)
                    .frame(width: 20)

                TextField(placeholder, text: $text)
                    .keyboardType(keyboard)
                    .font(.body)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(text.isEmpty ? Color.clear : Color.orange.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
