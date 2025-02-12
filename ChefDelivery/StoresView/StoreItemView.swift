//
//  StoreItemView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 29/05/23.
//
import SwiftUI

// Estrutura que representa a visualização de um item de loja
struct StoreItemView: View {
    var store: StoreType // Atributo para armazenar as informações da loja
    
    var body: some View {
        HStack { // Utiliza um HStack para organizar os elementos em linha horizontal
            // Exibe o logo da loja
            Image(store.logoImage) // Carrega a imagem do logo da loja
                .resizable() // Permite que a imagem seja redimensionada
                .scaledToFit() // Mantém a proporção da imagem
                .cornerRadius(25) // Arredonda os cantos da imagem
                .frame(width: 50, height: 50) // Define a largura e altura da imagem
            
            VStack(alignment: .leading) { // Utiliza um VStack para empilhar os elementos verticalmente
                Text(store.name) // Exibe o nome da loja
                    .font(.subheadline) // Define a fonte como subheadline
            }
            Spacer() // Adiciona um espaçador para empurrar os elementos à esquerda
        }
    }
}

// Estrutura para pré-visualização do StoreItemView
struct StoreItemView_Previews: PreviewProvider {
    static var previews: some View {
        StoreItemView(store: storesMock[0]) // Exibe a pré-visualização do primeiro item do mock de lojas
            .previewLayout(.sizeThatFits) // Define o layout da pré-visualização para se ajustar ao conteúdo
    }
}
