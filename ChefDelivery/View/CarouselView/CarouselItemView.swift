import SwiftUI

struct CarouselItemView: View {
    let order: OrderType

    var body: some View {
        Image(order.image)
            .resizable()
            .scaledToFill()
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}
