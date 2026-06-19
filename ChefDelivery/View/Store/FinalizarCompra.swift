import SwiftUI

struct FinalizarCompra: View {
    let cartItem: CartItem

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(url: cartItem.product.image, placeholder: "fork.knife", width: 80, height: 80, cornerRadius: 10)
            VStack(alignment: .leading, spacing: 4) {
                Text(cartItem.product.name).font(.headline)
                Text(cartItem.product.description).font(.caption).foregroundColor(.secondary)
                HStack {
                    if let price = cartItem.product.price {
                        Text(price, format: .currency(code: "BRL")).font(.subheadline)
                    }
                    Spacer()
                    Text("Qtd: \(cartItem.quantity)").font(.subheadline).foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
