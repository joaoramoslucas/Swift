import SwiftUI

struct CartItemRow: View {
    let cartItem: CartItem
    let onIncrease: () -> Void
    let onDecrease: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(
                url: cartItem.product.image,
                placeholder: "fork.knife",
                width: 70,
                height: 70,
                cornerRadius: 10
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(cartItem.product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                if let price = cartItem.product.price {
                    Text(price, format: .currency(code: "BRL"))
                        .font(.caption)
                        .foregroundColor(.green)
                }

                // Quantity Controls
                HStack(spacing: 14) {
                    Button(action: onDecrease) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(.plain)

                    Text("\(cartItem.quantity)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(width: 24)

                    Button(action: onIncrease) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text(cartItem.subTotal, format: .currency(code: "BRL"))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
