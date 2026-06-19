import SwiftUI

struct ProductListItemView: View {
    let product: ProductType

    var body: some View {
        HStack(spacing: 14) {
            RemoteImage(
                url: product.image,
                placeholder: "fork.knife",
                width: 90,
                height: 90,
                cornerRadius: 12
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Spacer()

                if let price = product.price {
                    Text(price, format: .currency(code: "BRL"))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 4)

            Spacer()
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}
