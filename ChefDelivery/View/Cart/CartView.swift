// CartView.swift
// ChefDelivery
//
// Created by Joao Lucas on 29/05/23.
//
import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(cartViewModel.items.indices, id: \.self) { index in
                        CartItemRow(cartItem: self.cartViewModel.items[index])
                    }
                    .onDelete(perform: deleteItem)
                }
                .listStyle(PlainListStyle())

                Spacer()

                Text(String(format: "Total: R$%.2f", self.cartViewModel.totalPrice))
                    .font(.title)
                    .padding()

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
                    NavigationLink(destination: CheckoutView()) {
                        Text("Finalizar Pedido")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.primary)
                }
            )
            .padding(.bottom, 20)
        }
    }
    private func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            self.cartViewModel.removeItem(at: index)
        }
    }
}
