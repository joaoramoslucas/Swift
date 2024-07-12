//
//  CarouselTabView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 18/05/23.
//

import SwiftUI // Importa o framework SwiftUI para construir a interface do usuário

// Estrutura que representa uma visualização de carrossel com abas
struct CarouselTabView: View {
    
    // Mock de dados para os tipos de pedidos a serem exibidos no carrossel
    let ordersMock: [OrderType] = [
        OrderType(id: 1, name: "banner burguer", image: "barbecue-banner"), // Item de burger
        OrderType(id: 2, name: "banner prato feito", image: "brazilian-meal-banner"), // Item de prato feito
        OrderType(id: 3, name: "banner poke", image: "pokes-banner"), // Item de poke
    ]
    
    var body: some View {
        // Componente de TabView para permitir a navegação entre os itens
        TabView {
            // Loop através dos itens mock e cria uma visualização para cada um
            ForEach(ordersMock) { mock in
                CarouselItemView(order: mock) // Exibe a visualização do item do carrossel
            }
        }
        .frame(height: 180) // Define a altura do TabView
        .tabViewStyle(.page(indexDisplayMode: .always)) // Estilo de página com indicadores visíveis
    }
}

// Estrutura para pré-visualização do CarouselTabView
struct CarouselTabView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselTabView() // Exibe a pré-visualização da visualização do carrossel
    }
}
