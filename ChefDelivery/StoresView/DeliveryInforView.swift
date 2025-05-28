import SwiftUI

struct DeliveryInfoView: View {
    @ObservedObject var checkoutViewModel: CheckoutViewModel
    @Binding var path: NavigationPath

    var body: some View {
        Form {
            Section(header: Text("Informações de Entrega")) {
                TextField("Nome", text: Binding(
                    get: { checkoutViewModel.name },
                    set: { checkoutViewModel.updateName($0) }
                ))
                TextField("Endereço", text: Binding(
                    get: { checkoutViewModel.address },
                    set: { checkoutViewModel.updateAddress($0) }
                ))
            }

            Button("Próximo: Pagamento") {
                path.append(AppRoute.payment)
            }
        }
        .navigationTitle("Entrega")
    }
}
