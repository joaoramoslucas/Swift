// CartView.swift
// ChefDelivery
//
// Created by Joao Lucas on 29/05/23.
//
import SwiftUI

// Estrutura que representa a tela do carrinho de compras
struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel // Acesso ao modelo de dados do carrinho
    @Environment(\.presentationMode) var presentationMode // Controla a apresentação da tela (fechar)

    var body: some View {
        NavigationView { // Cria uma nova visualização de navegação
            VStack { // Organiza os elementos da tela verticalmente
                List { // Inicia uma lista para exibir os itens do carrinho
                    ForEach(cartViewModel.items.indices, id: \.self) { index in
                        CartItemRow(cartItem: self.cartViewModel.items[index]) // Exibe cada item do carrinho em uma linha
                    }
                    .onDelete(perform: deleteItem) // Permite que os usuários removam itens deslizando
                }
                .listStyle(PlainListStyle()) // Define o estilo da lista como simples

                Spacer() // Espaço flexível para empurrar os elementos para cima

                // Exibe o total do carrinho formatado
                Text(String(format: "Total: R$%.2f", self.cartViewModel.totalPrice))
                    .font(.title) // Define o tamanho da fonte como título
                    .padding() // Adiciona espaçamento ao redor do texto

                HStack { // Organiza os botões horizontalmente
                    // Botão para limpar o carrinho
                    Button(action: {
                        self.cartViewModel.removeAll() // Limpa todos os itens do carrinho
                    }) {
                        Text("Limpar Carrinho") // Texto do botão
                            .padding() // Adiciona espaçamento interno ao botão
                            .background(Color.red) // Define a cor de fundo como vermelha
                            .foregroundColor(.white) // Define a cor do texto como branca
                            .cornerRadius(10) // Arredonda os cantos do botão
                    }
                    // Botão para finalizar o pedido que navega para CheckoutView
                    NavigationLink(destination: CheckoutView()) {
                        Text("Finalizar Pedido") // Texto do botão
                            .padding() // Adiciona espaçamento interno ao botão
                            .background(Color.green) // Define a cor de fundo como verde
                            .foregroundColor(.white) // Define a cor do texto como branca
                            .cornerRadius(10) // Arredonda os cantos do botão
                    }
                }
                .padding() // Adiciona espaçamento ao redor do HStack
                .frame(maxWidth: .infinity, alignment: .center) // Centraliza o HStack horizontalmente
            }
            .navigationBarItems(trailing: // Itens da barra de navegação à direita
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss() // Fecha a tela do carrinho
                }) {
                    Image(systemName: "xmark") // Ícone "x" para fechar a tela
                        .foregroundColor(.black) // Define a cor do ícone como preto
                }
            )
            .padding(.bottom, 20) // Ajusta a margem inferior da tela
        }
    }
    // Função para deletar um item da lista
    private func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            self.cartViewModel.removeItem(at: index) // Remove o item do carrinho
        }
    }
}
// PreviewProvider para visualizar a tela no Xcode
struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        let cartViewModel = CartViewModel()
        return CartView()
            .environmentObject(cartViewModel)
    }
}
