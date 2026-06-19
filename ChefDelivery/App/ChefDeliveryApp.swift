import SwiftUI
import FirebaseCore
import FirebaseAuth

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
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isAdmin") private var isAdmin: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                if isAdmin {
                    NavigationStack {
                        StorageHome()
                    }
                    .environmentObject(cartViewModel)
                } else {
                    ContentView(isLoggedIn: true, isAdmin: false)
                        .environmentObject(cartViewModel)
                        .onReceive(NotificationCenter.default.publisher(for: .userDidLogout)) { _ in
                            isLoggedIn = false
                            isAdmin = false
                        }
                }
            } else {
                LoginView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
            }
        }
    }
}

extension Notification.Name {
    static let userDidLogout = Notification.Name("userDidLogout")
    static let orderCompleted = Notification.Name("orderCompleted")
}
