import SwiftUI

struct StoreDetailView: View {
    let store: AllStoresTypes

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                StoreHeaderSection(store: store)

                VStack(alignment: .leading, spacing: 16) {
                    if let products = store.products, !products.isEmpty {
                        Text("Cardápio")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.top, 20)

                        ForEach(products, id: \.id) { product in
                            NavigationLink {
                                ProductDetailView(product: product)
                            } label: {
                                ProductListItemView(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Nenhum produto disponível")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}
