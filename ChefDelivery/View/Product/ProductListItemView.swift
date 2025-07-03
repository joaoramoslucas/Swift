import SwiftUI

struct ProductListItemView: View {
    let product: ProductType

    var body: some View {
        HStack(spacing: 15) {
            if let productImageName = product.image {
                Image(productImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 100)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 2, y: 2)
            } else {
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if let price = product.price {
                    Text(price.formatted(.currency(code: "BRL")))
                        .font(.callout)
                        .foregroundColor(.green)
                } else {
                    Text("Preço não disponível")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
