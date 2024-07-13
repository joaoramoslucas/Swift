import SwiftUI

// Estrutura que representa a tela de login
struct LoginView: View {
    @Binding var isLoggedIn: Bool // Variável ligada ao estado de login, controla se o usuário está logado
    @State private var email: String = "" // Armazena o email do usuário
    @State private var password: String = "" // Armazena a senha do usuário

    var body: some View {
        ZStack { // Camada de sobreposição para gerenciar a exibição de elementos
            Color(red: 0.85, green: 0.75, blue: 0.69) // Cor bege de fundo
        
            VStack { // Organiza os elementos verticalmente
                Spacer() // Espaço flexível que empurra os elementos para cima

                // Ícone de usuário no topo da tela
                Image(systemName: "person.circle.fill")
                    .resizable() // Permite que a imagem seja redimensionada
                    .frame(width: 100, height: 100) // Define o tamanho da imagem
                    .padding(.bottom, 50) // Adiciona espaço abaixo da imagem

                // Contêiner para os campos de entrada e botões
                VStack(spacing: 20) { // Organiza elementos verticalmente com espaçamento
                    // Campo de texto para o email
                    TextField("Email", text: $email) // Campo de texto que liga a variável email
                        .padding() // Adiciona espaçamento interno
                        .background(Color.white) // Cor de fundo branca para o campo de email
                        .cornerRadius(10) // Arredonda os cantos do campo
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Adiciona uma borda arredondada
                                .stroke(Color.black.opacity(0.5), lineWidth: 1) // Define a cor e espessura da borda
                        )
                        .padding(.horizontal, 20) // Adiciona espaçamento horizontal
                        .foregroundColor(.black) // Cor do texto escura

                    // Campo de texto para a senha
                    SecureField("Senha", text: $password) // Campo seguro para entrada de senha
                        .padding() // Adiciona espaçamento interno
                        .background(Color.white) // Cor de fundo branca para o campo de senha
                        .cornerRadius(10) // Arredonda os cantos do campo
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Adiciona uma borda arredondada
                                .stroke(Color.black.opacity(0.5), lineWidth: 1) // Define a cor e espessura da borda
                        )
                        .padding(.horizontal, 20) // Adiciona espaçamento horizontal
                        .foregroundColor(.black) // Cor do texto escura

                    // Botão de login
                    Button(action: {
                        isLoggedIn = true // Muda o estado para logado ao clicar no botão
                    }) {
                        Text("Login") // Texto do botão
                            .font(.headline) // Define o estilo da fonte como título
                            .foregroundColor(.white) // Define a cor do texto como branca
                            .padding() // Adiciona espaçamento interno ao botão
                            .frame(width: 200, height: 50) // Define a largura e altura do botão
                            .background(Color.red) // Define a cor de fundo do botão como azul
                            .cornerRadius(10) // Arredonda os cantos do botão
                    }

                    // Contêiner horizontal para os botões sociais
                    HStack { // Organiza os botões horizontalmente
                        socialButton(title: "", icon: "globe", color: .red) // Botão para login com Google
                        socialButton(title: "", icon: "f.square", color: .blue) // Botão para login com Facebook
                        socialButton(title: "", icon: "phone", color: .green) // Botão para login com telefone
                    }
                }
                .padding(.bottom, 100) // Adiciona espaçamento na parte inferior do contêiner
            }
        }
    }
    
    // Função que cria um botão social genérico
    private func socialButton(title: String, icon: String, color: Color) -> some View {
        Button(action: {
            // Ação do botão a ser implementada
        }) {
            HStack { // Organiza ícone e texto horizontalmente
                Image(systemName: icon) // Exibe o ícone do botão
                // Text(title) // Exibe o título do botão
            }
            .font(.headline) // Define o estilo da fonte como título
            .foregroundColor(.white) // Define a cor do texto como branca
            .padding() // Adiciona espaçamento interno ao botão
            .frame(width: 70, height: 50) // Define a largura e altura do botão
            .background(color) // Define a cor de fundo do botão
            .cornerRadius(100) // Arredonda os cantos do botão
        }
    }
}
