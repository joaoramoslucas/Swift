import SwiftUI

struct OrderTypeView: View {
    let orderType: OrderType

    var body: some View {
        VStack(spacing: 8) {
            Image(orderType.image)
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)

            Text(orderType.name)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .frame(width: 76)
    }
}
