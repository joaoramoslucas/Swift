//
//  CarouselItemView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 18/05/23.
//

import SwiftUI // Importa o framework SwiftUI para construir a interface do usuário

// Estrutura que representa uma visualização de item em um carrossel
struct CarouselItemView: View {
    
    // Propriedade que armazena o tipo de pedido a ser exibido no carrossel
    let order: OrderType
    
    var body: some View {
        // Exibe a imagem associada ao tipo de pedido
        Image(order.image)
            .resizable() // Permite que a imagem seja redimensionada
            .scaledToFit() // Ajusta a imagem para manter sua proporção
            .cornerRadius(12) // Adiciona bordas arredondadas à imagem
    }
}

// Estrutura para pré-visualização da CarouselItemView
struct CarouselItemView_Previews: PreviewProvider {
    static var previews: some View {
        // Cria uma instância da CarouselItemView com um exemplo de tipo de pedido
        CarouselItemView(order: OrderType(id: 1, name: "", image: "barbecue-banner"))
            .previewLayout(.sizeThatFits) // Ajusta a pré-visualização para se adaptar ao conteúdo
            .padding() // Adiciona espaçamento ao redor da visualização
    }
}
