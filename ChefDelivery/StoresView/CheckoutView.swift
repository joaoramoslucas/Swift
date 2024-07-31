//
//  CheckoutView.swift
//  ChefDelivery
//
//  Created by Jao on 31/07/24.
//
import SwiftUI

// Estrutura que representa a tela de checkout
struct CheckoutView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @StateObject private var checkoutViewModel = CheckoutViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Informações de Entrega")
                .font(.headline)
                .padding(.bottom, 10)
            
            TextField("Nome", text: $checkoutViewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            TextField("Endereço", text: $checkoutViewModel.address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            Text("Informações de Pagamento")
                .font(.headline)
                .padding(.vertical, 10)
            
            TextField("Número do Cartão", text: $checkoutViewModel.cardNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            TextField("Data de Validade (MM/AA)", text: $checkoutViewModel.expirationDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            TextField("CVV", text: $checkoutViewModel.cvv)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
            
            NavigationLink(destination: StoresContainerView()) {
                
            }
            
            Button(action: {
                checkoutViewModel.confirmOrder()
                cartViewModel.removeAll()
            }) {
                Text("Confirmar Pedido")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $checkoutViewModel.isOrderConfirmed) {
                Alert(
                    title: Text("Pedido Confirmado"),
                    message: Text("Seu pedido foi confirmado com sucesso!"),
                    dismissButton: .default(Text("OK")) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle("Pagamento", displayMode: .inline)
    }
}


class CheckoutViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var cardNumber: String = ""
    @Published var expirationDate: String = ""
    @Published var cvv: String = ""
    @Published var isOrderConfirmed: Bool = false
    
    func confirmOrder() {
        isOrderConfirmed = true
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView()
                .environmentObject(CartViewModel())
        }
    }
}
