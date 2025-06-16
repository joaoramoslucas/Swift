import SwiftUI

enum AppRoute: Hashable {
    case delivery
    case payment
}

struct CheckoutView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @StateObject private var checkoutViewModel = CheckoutViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            DeliveryInfoView(checkoutViewModel: checkoutViewModel, path: $path)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .delivery:
                        DeliveryInfoView(checkoutViewModel: checkoutViewModel, path: $path)
                    case .payment:
                        PaymentInfoView(checkoutViewModel: checkoutViewModel, path: $path)
                            .environmentObject(cartViewModel)
                    }
                }
        }
    }
}
