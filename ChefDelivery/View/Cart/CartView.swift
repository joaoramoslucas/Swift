import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if cartViewModel.items.isEmpty {
                    emptyCartView
                } else {
                    List {
                        ForEach(cartViewModel.items.indices, id: \.self) { index in
                            CartItemRow(
                                cartItem: cartViewModel.items[index],
                                onIncrease: { cartViewModel.increaseQuantity(at: index) },
                                onDecrease: { cartViewModel.decreaseQuantity(at: index) }
                            )
                        }
                        .onDelete(perform: deleteItem)
                    }
                    .listStyle(.plain)

                    // Bottom Bar
                    VStack(spacing: 14) {
                        Divider()

                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text(cartViewModel.totalPrice, format: .currency(code: "BRL"))
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)

                        HStack(spacing: 12) {
                            Button(action: { cartViewModel.removeAll() }) {
                                Text("Limpar")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .cornerRadius(12)
                            }

                            NavigationLink(destination: CheckoutView().environmentObject(cartViewModel)) {
                                Text("Finalizar Pedido")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    }
                }
            }
            .navigationTitle("Carrinho")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    private var emptyCartView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.4))

            Text("Seu carrinho está vazio")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Adicione produtos de uma loja")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        offsets.forEach { cartViewModel.removeItem(at: $0) }
    }
}
