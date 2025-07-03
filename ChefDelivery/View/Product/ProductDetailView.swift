import SwiftUI

struct ProductDetailView: View {
    @State private var quantity: Int = 1
    @State private var totalPrice: Double = 0.0
    @EnvironmentObject var cartViewModel: CartViewModel
    let product: ProductType
    
    @State private var isShowingCart: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                if let productImageName = product.image {
                    Image(productImageName)
                        .resizable().scaledToFit().cornerRadius(13)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 4, y: 4)
                        .frame(height: 270)
                } else {
                    Image(systemName: "photo")
                        .resizable().scaledToFit().cornerRadius(13)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 4, y: 4)
                        .frame(height: 270)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name).font(.title).bold()
                    Text(product.description).foregroundColor(.secondary).font(.headline)
                }.padding(.horizontal)
                
                Spacer()
                
                if let price = product.price {
                    Text(price.formatted(.currency(code: "BRL")))
                        .font(.title).bold().padding(.horizontal)
                } else {
                    Text("Preço não disponível").font(.title).bold().foregroundColor(.gray).padding(.horizontal)
                }
                
                Spacer()
                
                HStack {
                    Button(action: { if quantity > 1 { quantity -= 1 } }) {
                        Image(systemName: "minus.circle").font(.title)
                    }
                    Text("\(quantity)").font(.title).bold().padding(.horizontal, 20)
                    Button(action: { quantity += 1 }) {
                        Image(systemName: "plus.circle").font(.title)
                    }
                }.padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Text("Total:").font(.title2).bold().padding(.horizontal)
                    Spacer()
                    Text(formatCurrency((product.price ?? 0.0) * Double(quantity)))
                        .font(.title2).bold().padding(.horizontal)
                }
                
                Spacer()
                
                Button(action: {
                    adicionarSacola()
                }) {
                    Text("Adicionar ao Carrinho").foregroundColor(.white).bold().font(.headline).padding()
                        .frame(maxWidth: .infinity).background(Color.green).cornerRadius(12)
                        .padding(.horizontal).shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20)
            }
            .navigationTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isShowingCart) {
            CartView()
                .environmentObject(cartViewModel)
        }
        .onAppear {
            totalPrice = (product.price ?? 0.0) * Double(quantity)
        }
        .onChange(of: quantity) { _ in
            totalPrice = (product.price ?? 0.0) * Double(quantity)
        }
    }

    func adicionarSacola() {
        cartViewModel.addItem(product: product, quantity: quantity)
        isShowingCart = true
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}
