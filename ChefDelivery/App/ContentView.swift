//
//  ContentView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import SwiftUI // Importa o framework SwiftUI para construir a interface do usuário

// Estrutura principal da tela de conteúdo
struct ContentView: View {
    @State private var isMenuOpen: Bool = false // Controla se o menu lateral está aberto
    @EnvironmentObject var cartViewModel: CartViewModel // Acesso ao ViewModel do carrinho
    @State private var showLogin: Bool = false // Controla a navegação para a tela de login
    @State private var isLoggedIn: Bool = true // Estado de login do usuário

    // Corpo principal da visualização
    var body: some View {
        NavigationStack { // Navegação empilhada para gerenciar as telas
            ZStack { // Usado para sobrepor views
                if isLoggedIn { // Verifica se o usuário está logado
                    // Tela principal do aplicativo
                    VStack {
                        NavigationBar() // Exibe a barra de navegação
                            .padding(.horizontal, 15) // Adiciona espaçamento horizontal na barra

                        ScrollView(.vertical, showsIndicators: false) { // Rolagem vertical sem indicadores
                            VStack(spacing: 20) { // Empilha verticalmente com espaçamento de 20
                                OrderTypeGridView() // Grid de tipos de pedido
                                CarouselTabView() // Carrossel de itens
                                StoresContainerView() // Container de lojas
                            }
                        }
                    }
                    
                    // Botão para abrir o menu lateral
                    Button(action: {
                        withAnimation { // Animação ao abrir o menu
                            isMenuOpen.toggle() // Alterna o estado do menu
                        }
                    }) {
                        Image(systemName: "line.horizontal.3") // Ícone do menu
                            .font(.largeTitle) // Define o tamanho da fonte do ícone
                            .foregroundColor(.red) // Cor do ícone
                            .padding() // Adiciona espaçamento interno
                    }
                    .frame(height: 30) // Define a altura do botão
                    .position(x: 50, y: 15) // Posição do botão no layout

                    // Menu lateral
                    if isMenuOpen { // Verifica se o menu está aberto
                        Color.black.opacity(0.5) // Fundo escuro para o menu
                            .ignoresSafeArea() // Ignora áreas seguras
                            .onTapGesture { // Fecha o menu ao tocar fora dele
                                withAnimation {
                                    isMenuOpen = false
                                }
                            }

                        VStack(spacing: 0) { // Empilha elementos do menu sem espaçamento
                            Spacer().frame(height: 10) // Espaço superior

                            ScrollView { // Rolagem vertical dentro do menu
                                VStack(spacing: 0) { // Empilha elementos do menu
                                    Button("Ver Perfil") {
                                        // Ação para ver perfil
                                    }
                                    .buttonStyle(MenuButtonStyle()) // Estilo do botão

                                    Divider() // Linha de separação

                                    Button("Ver Carrinho") {
                                        // Ação para ver carrinho
                                    }
                                    .buttonStyle(MenuButtonStyle()) // Estilo do botão

                                    Divider() // Linha de separação

                                    Button("Adicionar Forma de Pagamento") {
                                        // Ação para adicionar pagamento
                                    }
                                    .buttonStyle(MenuButtonStyle()) // Estilo do botão

                                    Divider() // Linha de separação

                                    // Botão "Sair da Conta"
                                    Button(action: {
                                        isLoggedIn = false // Altera o estado de login
                                        isMenuOpen = false // Fecha o menu ao sair
                                    }) {
                                        Text("Sair da Conta") // Texto do botão
                                            .font(.system(size: 18, weight: .bold)) // Estilo do texto
                                            .foregroundColor(.red) // Cor do texto
                                            .frame(maxWidth: .infinity) // Largura máxima do botão
                                            .padding() // Adiciona espaçamento interno
                                    }
                                    .buttonStyle(MenuButtonStyle()) // Estilo do botão
                                }
                                .padding(.vertical) // Adiciona espaçamento vertical ao conteúdo do menu
                            }

                            Spacer().frame(height: 10) // Espaço inferior
                        }
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2) // Tamanho do menu
                        .background(Color.white) // Fundo branco do menu
                        .cornerRadius(20, corners: [.topLeft, .topRight]) // Cantos arredondados
                        .shadow(radius: 10) // Sombra do menu
                        .padding(.top, 0) // Margem superior
                        .offset(y: UIScreen.main.bounds.height / 2.5) // Posição do menu
                        .transition(.move(edge: .bottom)) // Transição ao abrir/fechar
                        .animation(.easeInOut, value: isMenuOpen) // Animação do menu
                    }
                } else {
                    // Tela de Login
                    LoginView(isLoggedIn: $isLoggedIn) // Exibe a tela de login
                        .navigationBarBackButtonHidden(true) // Esconde o botão de voltar
                        .onAppear {
                            isMenuOpen = false // Fecha o menu ao voltar para a tela de login
                        }
                }
            }
            .background(
                NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn), isActive: $showLogin) {
                    EmptyView() // Link para a tela de login
                }
                .hidden() // Esconde o link
            )
        }
    }
}

// Estilo do botão do menu
struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label // Usa o rótulo do botão
            .frame(maxWidth: .infinity) // Tamanho máximo do botão
            .padding() // Espaçamento interno
            .background(Color.white) // Fundo branco
            .foregroundColor(.black) // Cor do texto
            .multilineTextAlignment(.center) // Alinhamento do texto
            .opacity(configuration.isPressed ? 0.5 : 1.0) // Opacidade ao pressionar
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CartViewModel() // Cria uma instância do ViewModel do carrinho
        ContentView() // Exibe a ContentView
            .environmentObject(viewModel) // Passa o ViewModel como objeto de ambiente
    }
}

// Extensão para bordas arredondadas
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners)) // Aplica bordas arredondadas
    }
}

// Estrutura para definir cantos arredondados
struct RoundedCorner: Shape {
    var radius: CGFloat // Raio da borda
    var corners: UIRectCorner // Especifica quais cantos arredondar

    // Define o caminho da forma
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath) // Retorna o caminho arredondado
    }
}
