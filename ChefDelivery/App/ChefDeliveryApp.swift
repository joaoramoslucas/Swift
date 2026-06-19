import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ChefDeliveryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var cartViewModel = CartViewModel()
    @State private var isLoggedIn: Bool = false
    @State private var isAdmin: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                if isAdmin {
                    NavigationStack {
                        StorageHome()
                    }
                    .environmentObject(cartViewModel)
                } else {
                    ContentView(isLoggedIn: isLoggedIn, isAdmin: isAdmin)
                        .environmentObject(cartViewModel)
                }
            } else {
                LoginView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
            }
        }
    }
}
