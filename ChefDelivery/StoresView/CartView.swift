import SwiftUI

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    
    func addItem(product: ProductType, quantity: Int) {
        let cartItem = CartItem(product: product, quantity: quantity)
        items.append(cartItem)
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    func removeAll() {
        items.removeAll()
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.subTotal }
    }
}

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(cartViewModel.items.indices, id: \.self) { index in
                        CartItemRow(cartItem: self.cartViewModel.items[index])
                    }
                    .onDelete(perform: deleteItem)
                }
                
                Spacer()
                
                Text(String(format: "Total: R$%.2f", self.cartViewModel.totalPrice))
                    .font(.title)
                    
                HStack {
                    Button(action: {
                        self.cartViewModel.removeAll()
                    }) {
                        Text("Limpar Carrinho")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()

                    NavigationLink(destination: CheckoutView()) {
                        Text("Finalizar Pedido")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Carrinho")

        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            self.cartViewModel.removeItem(at: index)
        }
    }
}

struct CartItemRow: View {
    let cartItem: CartItem
    
    var body: some View {
        HStack(spacing: 10) {
            Image(cartItem.product.image)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(cartItem.product.name)
                    .font(.headline)
                
                Text(cartItem.product.description)
                    .foregroundColor(.gray)
                
                HStack {
                    Text(cartItem.product.formatPrice)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("Quantity: \(cartItem.quantity)")
                        .font(.subheadline)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct CheckoutView: View {
    var body: some View {
        Text("Finalizar Compra")
            .navigationBarTitle("Checkout")
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CartViewModel()
        viewModel.addItem(product: ProductType(id: 1, name: "Product A", description: "Description of Product A", image: "productA", price: 10.0), quantity: 2)
        viewModel.addItem(product: ProductType(id: 2, name: "Product B", description: "Description of Product B", image: "productB", price: 15.0), quantity: 1)
        return CartView()
            .environmentObject(viewModel)
    }
}
