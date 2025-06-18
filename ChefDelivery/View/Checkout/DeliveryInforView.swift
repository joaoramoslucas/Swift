import SwiftUI

struct DeliveryInfoView: View {
    @ObservedObject var checkoutViewModel: CheckoutViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 20) {
            Text("Informações de Entrega")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    TextField("Nome completo", text: Binding(
                        get: { checkoutViewModel.name },
                        set: { checkoutViewModel.updateName($0) }
                    ))
                    .autocapitalization(.words)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                HStack {
                    Image(systemName: "house.fill")
                        .foregroundColor(.gray)
                    TextField("Endereço de entrega", text: Binding(
                        get: { checkoutViewModel.address },
                        set: { checkoutViewModel.updateAddress($0) }
                    ))
                    .autocapitalization(.words)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top, 10)

            Spacer()

            Button(action: {
                path.append(AppRoute.payment)
            }) {
                HStack {
                    Spacer()
                    Text("Próximo: Pagamento")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 3)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding(.top)
        .background(Color.white.ignoresSafeArea())
    }
}
