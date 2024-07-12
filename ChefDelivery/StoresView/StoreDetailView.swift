import SwiftUI

struct StoreDetailView: View {
    let store: StoreType
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Image(store.headerImage)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    Text(store.name)
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Image(store.logoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                
                HStack {
                    Text(store.location)
                    
                    Spacer()
                    
                    ForEach(1...store.stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                
                ForEach(store.products) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductRow(product: product)
                    }
                    .buttonStyle(PlainButtonStyle()) // Para remover o estilo padrão de navegação
                }
                
            }
            .navigationTitle(store.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProductRow: View {
    let product: ProductType
    
    var body: some View {
        HStack(spacing: 16) {
            Image(product.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 2, y: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                    .bold()
                
                Text(product.description)
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.5))
                    .lineLimit(2)
                
                Text(product.formatPrice)
                    .font(.headline)
                    .bold()
            }
            .padding(.trailing, 8)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 2, y: 4)
        .padding(.horizontal)
    }
}

struct StoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreDetailView(store: storesMock[0])
    }
}
