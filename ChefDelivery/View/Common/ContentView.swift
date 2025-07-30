import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool
    @State var isAdmin: Bool
    
    @State private var isMenuOpen: Bool = false
    @State private var showCart: Bool = false
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var isDarkMode: Bool = false
    @StateObject private var storeViewModel = StoreViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                if isLoggedIn {
                    VStack {
                        NavigationBar()
                            .padding(.horizontal, 15)
                                                
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 20) {
                                OrderTypeGridView()
                                CarouselTabView()
                                StoresContainerView(viewModel: storeViewModel)
                            }
                        }
                    }
                    Button(action: { isDarkMode.toggle() }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.red)
                    }
                    .position(x: UIScreen.main.bounds.width - 72, y: 17)
                    
                    Button(action: { withAnimation { isMenuOpen.toggle() } }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .padding()
                    }
                    .position(x: 40, y: 15)
                    
                    if isMenuOpen {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture { withAnimation { isMenuOpen = false } }
                        
                        VStack(spacing: 0) {
                            Spacer().frame(height: 10)
                            ScrollView {
                                VStack(spacing: 0) {
                                    Button("Ver Perfil") {}.buttonStyle(MenuButtonStyle())
                                    Divider()
                                    Button("Ver Carrinho") { showCart = true; isMenuOpen = false }.buttonStyle(MenuButtonStyle())
                                    Divider()
                                    Button("Adicionar Forma de Pagamento") {}.buttonStyle(MenuButtonStyle())
                                    Divider()
                                    Button(action: { isLoggedIn = false; isMenuOpen = false }) {
                                        Text("Sair da Conta").font(.system(size: 18, weight: .bold)).foregroundColor(.red)
                                            .frame(maxWidth: .infinity).padding()
                                    }.buttonStyle(MenuButtonStyle())
                                }
                                .padding(.vertical)
                            }
                            Spacer().frame(height: 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding(.top, 0)
                        .offset(y: UIScreen.main.bounds.height / 2.5)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isMenuOpen)
                    }
                } else {
                    LoginView(isLoggedIn: $isLoggedIn, isAdmin: $isAdmin)
                        .navigationBarBackButtonHidden(true)
                        .onAppear { isMenuOpen = false }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .sheet(isPresented: $showCart) {
            CartView().environmentObject(cartViewModel)
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    ContentView(isLoggedIn: true, isAdmin:  false)
}

