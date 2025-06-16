//
//  OrderTypeView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import SwiftUI // Importa o framework SwiftUI para criar a interface do usuário

// Estrutura que representa a visualização de um tipo de pedido
struct OrderTypeView: View {
    
    // Propriedade que armazena o tipo de pedido a ser exibido
    let orderType: OrderType
    
    var body: some View {
        // VStack empilha os elementos verticalmente com espaçamento de 5
        VStack(spacing: 5) {
            // Imagem do tipo de pedido, redimensionada e ajustada para caber na área
            Image(orderType.image)
                .resizable() // Permite redimensionamento
                .scaledToFit() // Ajusta a imagem para manter a proporção
                .fixedSize(horizontal: false, vertical: true) // Permite que a altura seja ajustada livremente
            
            // Texto exibindo o nome do tipo de pedido
            Text(orderType.name)
                .font(.system(size: 10)) // Define o tamanho da fonte como 10
        }
        // Define a largura e a altura do container da visualização
        .frame(width: 70, height: 100)
    }
}

// Estrutura para pré-visualização da OrderTypeView
struct OrderTypeView_Previews: PreviewProvider {
    static var previews: some View {
        // Cria uma instância da OrderTypeView com um exemplo de tipo de pedido
        OrderTypeView(orderType: OrderType(id: 1,
                                           name: "Restaurantes",
                                           image: "hamburguer"))
        .previewLayout(.sizeThatFits) // Ajusta a pré-visualização para se ajustar ao conteúdo
    }
}
