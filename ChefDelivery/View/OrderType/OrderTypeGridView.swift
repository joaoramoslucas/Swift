import SwiftUI

struct OrderTypeGridView: View {
    let ordersMock: [OrderType] = [
        OrderType(id: 1, name: "Restaurantes", image: "hamburguer"),
        OrderType(id: 2, name: "Farmácia", image: "farmacia"),
        OrderType(id: 3, name: "Descontos", image: "descontos"),
        OrderType(id: 4, name: "Gourmet", image: "gourmet"),
        OrderType(id: 5, name: "Mercado", image: "mercado"),
        OrderType(id: 6, name: "Pet", image: "petshop"),
        OrderType(id: 7, name: "Bebidas", image: "bebidas"),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(ordersMock, id: \.id) { orderItem in
                    OrderTypeView(orderType: orderItem)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}
