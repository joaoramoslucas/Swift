import SwiftUI

struct ProductDetailView: View {
    @State private var quantity: Int = 1
    @State private var totalPrice: Double = 0.0
    @EnvironmentObject var cartViewModel: CartViewModel // Ambiente do ViewModel do Carrinho
    let product: ProductType
    
    @State private var isShowingCart: Bool = false // Estado para controlar a navegação para o carrinho
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Imagem do produto
                Image(product.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(13)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 4, y: 4)
                    .frame(height: 250)
                
                // Título e Descrição
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.title)
                        .bold()
                    
                    Text(product.description)
                        .foregroundColor(.secondary)
                        .font(.body)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Preço
                Text(product.formatPrice)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                Spacer()
                
                // Controles de Quantidade
                HStack {
                    Button(action: {
                        if quantity > 1 {
                            quantity -= 1
                            updateTotalPrice()
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.title)
                    }
                    
                    Text("\(quantity)")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        quantity += 1
                        updateTotalPrice()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Text("Total:")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    Text("\(formatCurrency(totalPrice))")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                }
                
                Spacer() // Espaço para mover o botão para baixo
                
                // Botão de Adicionar à Sacola
                Button(action: {
                    adicionarSacola()
                }) {
                    Text("Adicionar à Sacola")
                        .foregroundColor(.white)
                        .bold()
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20) // Espaço adicional para o botão na parte inferior
            }
            .onAppear {
                updateTotalPrice()
            }
            .navigationTitle(product.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $isShowingCart) {
            CartView()
        }
    }
    
    func updateTotalPrice() {
        totalPrice = Double(quantity) * product.price
    }
    
    func adicionarSacola() {
        cartViewModel.addItem(product: product, quantity: quantity)
        isShowingCart = true // Mostra o carrinho após adicionar à sacola
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR") // Formato de moeda brasileiro
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CartViewModel()
        viewModel.addItem(product: ProductType(id: 1, name: "Product A", description: "Description of Product A", image: "productA", price: 10.0), quantity: 1)
        return ProductDetailView(product: ProductType(id: 1, name: "Product A", description: "Description of Product A", image: "productA", price: 10.0))
            .environmentObject(viewModel) // Passa o ViewModel do Carrinho para a pré-visualização
    }
}
