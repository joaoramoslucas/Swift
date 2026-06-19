import SwiftUI

struct CarouselTabView: View {
    let ordersMock: [OrderType] = [
        OrderType(id: 1, name: "banner burguer", image: "barbecue-banner"),
        OrderType(id: 2, name: "banner prato feito", image: "brazilian-meal-banner"),
        OrderType(id: 3, name: "banner poke", image: "pokes-banner"),
        OrderType(id: 4, name: "japonesa", image: "japanese-banner"),
        OrderType(id: 5, name: "mexicana", image: "mexican-banner"),
        OrderType(id: 6, name: "brasileira", image: "brazilian-banner")
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
