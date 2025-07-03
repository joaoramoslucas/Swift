//
//  CarouselTabView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 18/05/23.
//

import SwiftUI

struct CarouselTabView: View {
    let ordersMock: [OrderType] = [
        OrderType(id: 1, name: "Restaurantes", image: "hamburguer"),
        OrderType(id: 2, name: "Mercado", image: "mercado"),
        OrderType(id: 3, name: "Farmácia", image: "farmacia"),
        OrderType(id: 4, name: "Pet", image: "petshop"),
        OrderType(id: 5, name: "Descontos", image: "descontos"),
        OrderType(id: 6, name: "Bebidas", image: "bebidas"),
        OrderType(id: 7, name: "Gourmet", image: "gourmet"),
    ]
    
    var body: some View {
        TabView {
            ForEach(ordersMock, id: \.id) { mock in
                CarouselItemView(order: mock)
            }
        }
        .frame(height: 180)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
