import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool
    @State var isAdmin: Bool

    @State private var isMenuOpen: Bool = false
    @State private var showCart: Bool = false
    @State private var showCreateStore: Bool = false
    @State private var isDarkMode: Bool = false
    @StateObject private var storeViewModel = StoreViewModel()
    @EnvironmentObject var cartViewModel: CartViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                if isLoggedIn {
                    mainContent
                    sideMenu
                } else {
                    LoginView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .sheet(isPresented: $showCart) {
            CartView().environmentObject(cartViewModel)
        }
        .sheet(isPresented: $showCreateStore) {
            CreateStoreView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .orderCompleted)) { _ in
            showCart = false
        }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            NavigationBar(
                onMenuTap: { withAnimation(.spring()) { isMenuOpen.toggle() } },
                onCartTap: { showCart = true }
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    OrderTypeGridView()
                    CarouselTabView()
                    StoresContainerView(viewModel: storeViewModel)
                }
                .padding(.bottom, 30)
            }
        }
    }

    private var sideMenu: some View {
        Group {
            if isMenuOpen {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation(.spring()) { isMenuOpen = false } }

                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                            Text("Olá!")
                                .font(.title2).bold()
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.1))

                        // Menu Items
                        VStack(spacing: 0) {
                            menuItem(icon: "person", title: "Meu Perfil") {}
                            menuItem(icon: "bag", title: "Carrinho") {
                                showCart = true; isMenuOpen = false
                            }
                            menuItem(icon: "storefront", title: "Criar Minha Loja") {
                                showCreateStore = true; isMenuOpen = false
                            }
                            menuItem(icon: "creditcard", title: "Pagamentos") {}
                            Divider().padding(.vertical, 8)
                            menuItem(icon: isDarkMode ? "sun.max" : "moon", title: isDarkMode ? "Modo Claro" : "Modo Escuro") {
                                isDarkMode.toggle()
                            }
                            Spacer()
                            menuItem(icon: "rectangle.portrait.and.arrow.right", title: "Sair", color: .red) {
                                isMenuOpen = false
                                NotificationCenter.default.post(name: .userDidLogout, object: nil)
                            }
                        }
                        .padding(.top, 16)
                    }
                    .frame(width: 280)
                    .background(Color(.systemBackground))
                    .transition(.move(edge: .leading))

                    Spacer()
                }
            }
        }
    }

    private func menuItem(icon: String, title: String, color: Color = .primary, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.body)
                    .foregroundColor(color)
                    .frame(width: 24)
                Text(title)
                    .font(.body)
                    .foregroundColor(color)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    ContentView(isLoggedIn: true, isAdmin: false)
        .environmentObject(CartViewModel())
}
