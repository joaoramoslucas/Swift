import SwiftUI

struct ProductDetailView: View {
    let product: ProductType
    @State private var quantity: Int = 1
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var isShowingCart: Bool = false
    @State private var addedToCart: Bool = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Product Image
                RemoteImage(
                    url: product.image,
                    placeholder: "fork.knife",
                    width: UIScreen.main.bounds.width,
                    height: 280,
                    cornerRadius: 0
                )

                VStack(alignment: .leading, spacing: 20) {
                    // Name & Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }

                    Divider()

                    // Price
                    if let price = product.price {
                        Text(price, format: .currency(code: "BRL"))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }

                    // Quantity Selector
                    HStack {
                        Text("Quantidade")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()

                        HStack(spacing: 20) {
                            Button { if quantity > 1 { quantity -= 1 } } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(quantity > 1 ? .orange : .gray)
                            }
                            .disabled(quantity <= 1)

                            Text("\(quantity)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(width: 30)

                            Button { quantity += 1 } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    // Total
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text((product.price ?? 0) * Double(quantity), format: .currency(code: "BRL"))
                            .font(.title3)
                            .fontWeight(.bold)
                    }

                    // Add to Cart Button
                    Button(action: addToCart) {
                        HStack {
                            Image(systemName: addedToCart ? "checkmark" : "bag.badge.plus")
                            Text(addedToCart ? "Adicionado!" : "Adicionar ao Carrinho")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(addedToCart ? Color.green : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $isShowingCart) {
            CartView().environmentObject(cartViewModel)
        }
    }

    private func addToCart() {
        cartViewModel.addItem(product: product, quantity: quantity)
        addedToCart = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            addedToCart = false
            isShowingCart = true
        }
    }
}
