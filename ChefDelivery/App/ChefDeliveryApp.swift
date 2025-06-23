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

    @State private var isLoggedIn: Bool = false
    @State private var isAdmin: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                if isAdmin {
                    // View para administrador logado
                    StorageHome()
                        .environmentObject(CartViewModel())
                } else {
                    // View para usuário comum logado
                    ContentView()
                        .environmentObject(CartViewModel())
                }
            } else {
                // View de login
                LoginView(isLoggedIn: isLoggedIn, isAdmin: isAdmin)
            }
        }
    }
}
