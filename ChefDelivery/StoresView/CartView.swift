//
//  CartView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 29/05/23.
//
import SwiftUI

// Classe que representa o ViewModel do carrinho, responsável pela lógica do carrinho de compras
class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = [] // Array que armazena os itens do carrinho
    
    // Função para adicionar um item ao carrinho
    func addItem(product: ProductType, quantity: Int) {
        // Verifica se o item já existe no carrinho
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            // Se existir, atualiza a quantidade do item já presente
            items[index].quantity += quantity
        } else {
            // Se não existir, cria um novo CartItem e adiciona ao carrinho
            let cartItem = CartItem(product: product, quantity: quantity)
            items.append(cartItem) // Adiciona o novo item à lista
        }
    }
    // Função para remover um item do carrinho dado seu índice
    func removeItem(at index: Int) {
        items.remove(at: index) // Remove o item do array
    }
    // Função para remover todos os itens do carrinho
    func removeAll() {
        items.removeAll() // Limpa todos os itens
    }
    // Propriedade computada que calcula o preço total do carrinho
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.subTotal } // Soma todos os subtotais dos itens
    }
}
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
                    Spacer() // Espaço flexível entre os botões

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
            }
            .navigationBarTitle("Finalizar Compra") // Define o título da barra de navegação
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
// Estrutura que representa uma linha de item do carrinho
struct CartItemRow: View {
    let cartItem: CartItem // Recebe um item do carrinho para exibir

    var body: some View {
        HStack(spacing: 10) { // Organiza os elementos da linha horizontalmente
            // Exibe a imagem do produto
            Image(cartItem.product.image)
                .resizable() // Permite que a imagem seja redimensionada
                .scaledToFit() // Mantém a proporção da imagem
                .cornerRadius(10)
                .frame(width: 120, height: 120) // Define a largura e altura da imagem

            VStack(alignment: .leading) { // Organiza os textos verticalmente
                Text(cartItem.product.name) // Nome do produto
                    .font(.headline) // Define o estilo da fonte como título

                Text(cartItem.product.description) // Descrição do produto
                    .foregroundColor(.gray) // Define a cor do texto como cinza

                HStack { // Organiza informações de preço e quantidade
                    Text(cartItem.product.formatPrice) // Exibe o preço do produto
                        .font(.subheadline) // Define o estilo da fonte como subtítulo

                    Spacer() // Espaço flexível entre preço e quantidade

                    Text("Quantidade: \(cartItem.quantity)") // Exibe a quantidade do produto
                        .font(.subheadline) // Define o estilo da fonte como subtítulo
                }
            }
        }
        .padding(.vertical, 8) // Adiciona espaçamento vertical à linha
    }
}
// Estrutura que representa a tela de checkout
struct CheckoutView: View {
    var body: some View {
        Text("Finalizar Compra") // Texto para indicar que é a tela de checkout
            .navigationBarTitle("Finalizar Compra") // Define o título da barra de navegação
    }
}
