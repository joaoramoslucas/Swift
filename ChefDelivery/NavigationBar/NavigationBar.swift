//
//  NavigationBar.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import SwiftUI // Importa o framework SwiftUI para criar a interface do usuário

// Estrutura que representa a barra de navegação
struct NavigationBar: View {
    var body: some View {
        HStack { // HStack organiza os elementos horizontalmente
            Spacer() // Adiciona um espaço flexível à esquerda

            // Botão que exibe o endereço
            Button("R. Vergueiro, 3185") {
                // Ação do botão (pode ser implementada no futuro)
            }
            .font(.subheadline) // Define o tamanho da fonte
            .fontWeight(.semibold) // Define o peso da fonte
            .foregroundColor(.black) // Define a cor do texto como preto
            
            Spacer() // Adiciona um espaço flexível à direita

            // Botão que exibe o ícone de notificação
            Button(action: {}) {
                Image(systemName: "bell.badge") // Ícone de notificação do sistema
                    .font(.title3) // Define o tamanho da fonte do ícone
                    .foregroundColor(.red) // Define a cor do ícone como vermelho
            }
        }
    }
}

// Estrutura para pré-visualização da barra de navegação
struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar() // Cria uma instância da NavigationBar
            .previewLayout(.sizeThatFits) // Ajusta a pré-visualização para se ajustar ao conteúdo
            .padding() // Adiciona um preenchimento em torno da barra
    }
}
