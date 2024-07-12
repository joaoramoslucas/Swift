//
//  StoresContainerView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 29/05/23.
//

import SwiftUI // Importa o framework SwiftUI para construir a interface do usuário

// Estrutura que representa a visualização do container de lojas
struct StoresContainerView: View {
    
    var title = "Lojas" // Título da seção de lojas

    // Corpo da visualização
    var body: some View {
        VStack(alignment: .leading) { // Utiliza um VStack para empilhar elementos verticalmente, alinhando à esquerda
            Text(title) // Exibe o título da seção
                .font(.headline) // Define a fonte como headline
            
            VStack(alignment: .leading, spacing: 30) { // Outro VStack para empilhar os itens das lojas
                // Itera sobre os dados de lojas mockados
                ForEach(storesMock) { mock in
                    // Cria um link de navegação para a visualização de detalhes da loja
                    NavigationLink {
                        StoreDetailView(store: mock) // Redireciona para a StoreDetailView passando a loja selecionada
                    } label: {
                        StoreItemView(store: mock) // Exibe a visualização do item da loja
                    }
                }
            }
        }
        .padding(.horizontal, 20) // Adiciona preenchimento horizontal ao container
        .foregroundColor(.black) // Define a cor do texto como preto
    }
}

// Estrutura para pré-visualização do StoresContainerView
struct StoresContainerView_Previews: PreviewProvider {
    static var previews: some View {
        StoresContainerView() // Exibe a pré-visualização do container de lojas
            .previewLayout(.sizeThatFits) // Define o layout da pré-visualização para se ajustar ao conteúdo
    }
}
