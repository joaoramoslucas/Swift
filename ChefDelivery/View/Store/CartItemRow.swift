import SwiftUI

struct CartItemRow: View {
    let cartItem: CartItem

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(
                url: cartItem.product.image,
                placeholder: "fork.knife",
                width: 70,
                height: 70,
                cornerRadius: 10
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(cartItem.product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                HStack {
                    if let price = cartItem.product.price {
                        Text(price, format: .currency(code: "BRL"))
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    Spacer()
                    Text("x\(cartItem.quantity)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(6)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
