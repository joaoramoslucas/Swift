//
//  OrderTypeGridView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import SwiftUI // Importa o framework SwiftUI para criar a interface do usuário

// Estrutura que representa a visualização da grade de tipos de pedido
struct OrderTypeGridView: View {
    
    // Computed property que define o layout da grade
    var gridLayout: [GridItem] {
        // Cria um array de GridItem com dois itens flexíveis, com espaçamento de 10
        return Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    }
    
    var body: some View {
        // LazyHGrid permite uma grade horizontal com carregamento sob demanda
        LazyHGrid(rows: gridLayout, spacing: 15) {
            // Itera sobre os itens de pedidos mockados
            ForEach(ordersMock) { orderItem in
                // Exibe cada tipo de pedido usando a visualização OrderTypeView
                OrderTypeView(orderType: orderItem)
            }
        }
        .frame(height: 200) // Define a altura fixa da grade
        .padding(.horizontal, 15) // Adiciona preenchimento horizontal
        .padding(.top, 15) // Adiciona preenchimento no topo
    }
}

// Estrutura para pré-visualização da Grade de Tipos de Pedido
struct OrderTypeGridView_Previews: PreviewProvider {
    static var previews: some View {
        OrderTypeGridView() // Cria uma instância da OrderTypeGridView
            .previewLayout(.sizeThatFits) // Ajusta a pré-visualização para se ajustar ao conteúdo
    }
}
