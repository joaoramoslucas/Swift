import SwiftUI

struct OrderTypeGridView: View {
    var gridLayout: [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    }

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
        LazyHGrid(rows: gridLayout, spacing: 15) {
            ForEach(ordersMock, id: \.id) { orderItem in
                OrderTypeView(orderType: orderItem)
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 15)
        .padding(.top, 15)
    }
}

