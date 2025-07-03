import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool
    
    @State private var isMenuOpen: Bool = false
    @State private var showCart: Bool = false
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var isDarkMode: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                if isLoggedIn {
                    VStack {
                        NavigationBar()
                            .padding(.horizontal, 15)
                            .foregroundColor(isDarkMode ? .white : .black)
                                                
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 20) {
                                OrderTypeGridView()
                                    .foregroundColor(isDarkMode ? .white : .black)
                                CarouselTabView()
                                StoresContainerView(viewModel: StoreViewModel())
                                    .foregroundColor(isDarkMode ? .white : .black)
                            }
                        }
                    }
                    Button(action: { isDarkMode.toggle() }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.orange)
                    }
                    .position(x: UIScreen.main.bounds.width - 40, y: 15)
                    
                    Button(action: { withAnimation { isMenuOpen.toggle() } }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
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
                                    Button("Ver Perfil") {}.buttonStyle(MenuButtonStyle(isDarkMode: isDarkMode))
                                    Divider()
                                    Button("Ver Carrinho") { showCart = true; isMenuOpen = false }.buttonStyle(MenuButtonStyle(isDarkMode: isDarkMode))
                                    Divider()
                                    Button("Adicionar Forma de Pagamento") {}.buttonStyle(MenuButtonStyle(isDarkMode: isDarkMode))
                                    Divider()
                                    Button(action: { isLoggedIn = false; isMenuOpen = false }) {
                                        Text("Sair da Conta").font(.system(size: 18, weight: .bold)).foregroundColor(.red)
                                            .frame(maxWidth: .infinity).padding()
                                    }.buttonStyle(MenuButtonStyle(isDarkMode: isDarkMode))
                                }
                                .padding(.vertical)
                            }
                            Spacer().frame(height: 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
                        .background(isDarkMode ? Color.black : Color.white)
                        .cornerRadius(20) 
                        .shadow(radius: 10)
                        .padding(.top, 0)
                        .offset(y: UIScreen.main.bounds.height / 2.5)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isMenuOpen)
                    }
                } else {
                    LoginView(isLoggedIn: $isLoggedIn, isAdmin: .constant(false))
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
struct MenuButtonStyle: ButtonStyle {
    var isDarkMode: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDarkMode ? Color.black : Color.white)
            .foregroundColor(isDarkMode ? Color.white : Color.black)
            .multilineTextAlignment(.center)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
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
