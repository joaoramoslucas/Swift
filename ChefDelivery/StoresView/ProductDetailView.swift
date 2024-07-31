//
//  ProductTypeView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 29/05/23.
//

import SwiftUI

// Estrutura que representa a visualização de detalhes do produto
struct ProductDetailView: View {
    @State private var quantity: Int = 1 // Estado para controlar a quantidade do produto
    @State private var totalPrice: Double = 0.0 // Estado para armazenar o preço total
    @EnvironmentObject var cartViewModel: CartViewModel // Acesso ao ViewModel do Carrinho no ambiente
    let product: ProductType // Produto cujos detalhes serão exibidos
    
    @State private var isShowingCart: Bool = false // Estado para controlar a exibição do carrinho
    
    var body: some View {
        ScrollView { // Permite rolagem do conteúdo
            VStack(spacing: 18) { // Empilha os elementos verticalmente com espaçamento
            
                // Imagem do produto
                Image(product.image)
                    .resizable() // Permite redimensionamento da imagem
                    .scaledToFit() // Escala a imagem para caber no espaço
                    .cornerRadius(13) // Arredonda os cantos da imagem
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 4, y: 4) // Adiciona sombra
                    .frame(height: 270) // Define a altura da imagem
                
                // Título e descrição do produto
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name) // Nome do produto
                        .font(.title) // Define a fonte como título
                        .bold() // Define o texto como negrito
                    
                    Text(product.description) // Descrição do produto
                        .foregroundColor(.secondary) // Cor secundária para o texto
                        .font(.headline) // Define a fonte como corpo
                }
                .padding(.horizontal) // Preenchimento horizontal
                
                Spacer() // Espaço flexível para empurrar elementos para baixo
                
                // Exibição do preço do produto
                Text(product.formatPrice)
                    .font(.title) // Define a fonte como título
                    .bold() // Define o texto como negrito
                    .padding(.horizontal) // Preenchimento horizontal
                
                Spacer() // Espaço flexível
                
                // Controles de quantidade
                HStack {
                    // Botão para diminuir a quantidade
                    Button(action: {
                        if quantity > 1 {
                            quantity -= 1 // Decrementa a quantidade
                            updateTotalPrice() // Atualiza o preço total
                        }
                    }) {
                        Image(systemName: "minus.circle") // Ícone de menos
                            .font(.title) // Tamanho da fonte
                    }
                    
                    // Exibe a quantidade atual
                    Text("\(quantity)")
                        .font(.title) // Tamanho da fonte
                        .bold() // Texto em negrito
                        .padding(.horizontal, 20) // Preenchimento horizontal
                    
                    // Botão para aumentar a quantidade
                    Button(action: {
                        quantity += 1 // Incrementa a quantidade
                        updateTotalPrice() // Atualiza o preço total
                    }) {
                        Image(systemName: "plus.circle") // Ícone de mais
                            .font(.title) // Tamanho da fonte
                    }
                }
                .padding(.horizontal) // Preenchimento horizontal
                
                Spacer() // Espaço flexível
                
                // Exibe o total
                HStack {
                    Text("Total:") // Texto fixo "Total:"
                        .font(.title2) // Tamanho da fonte
                        .bold() // Texto em negrito
                        .padding(.horizontal) // Preenchimento horizontal
                    
                    Spacer() // Espaçador
                    
                    // Exibe o valor total formatado
                    Text("\(formatCurrency(totalPrice))")
                        .font(.title2) // Tamanho da fonte
                        .bold() // Texto em negrito
                        .padding(.horizontal) // Preenchimento horizontal
                }
                
                Spacer() // Espaço para mover o botão para baixo
                
                // Botão para adicionar o produto ao carrinho
                Button(action: {
                    adicionarSacola() // Chama a função para adicionar ao carrinho
                }) {
                    Text("Adicionar ao Carrinho") // Texto do botão
                        .foregroundColor(.white) // Cor do texto
                        .bold() // Texto em negrito
                        .font(.headline) // Tamanho da fonte
                        .padding() // Preenchimento interno
                        .frame(maxWidth: .infinity) // Largura máxima
                        .background(Color.red) // Cor de fundo
                        .cornerRadius(12) // Arredonda os cantos
                        .padding(.horizontal) // Preenchimento horizontal
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 4) // Adiciona sombra
                }
                .buttonStyle(PlainButtonStyle()) // Remove o estilo padrão do botão
                .padding(.bottom, 20) // Espaço adicional na parte inferior
            }
            .onAppear {
                updateTotalPrice() // Atualiza o preço total ao aparecer a visualização
            }
            .navigationTitle(product.name) // Define o título da navegação
            .navigationBarTitleDisplayMode(.inline) // Modo de exibição do título
        }
        .sheet(isPresented: $isShowingCart) {
            CartView() // Exibe o carrinho em uma folha
        }
    }
    
    // Função para atualizar o preço total
    func updateTotalPrice() {
        totalPrice = Double(quantity) * product.price // Calcula o preço total
    }
    
    // Função para adicionar o produto ao carrinho
    func adicionarSacola() {
        cartViewModel.addItem(product: product, quantity: quantity) // Adiciona o item ao carrinho
        isShowingCart = true // Mostra o carrinho após adicionar o item
    }
    
    // Função para formatar o valor como moeda
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter() // Cria um formatador de número
        formatter.numberStyle = .currency // Define o estilo como moeda
        formatter.locale = Locale(identifier: "pt_BR") // Define o formato para o Brasil
        return formatter.string(from: NSNumber(value: value)) ?? "" // Retorna a string formatada
    }
}

// Estrutura para pré-visualização da ProductDetailView
struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CartViewModel() // Cria uma instância do ViewModel do Carrinho
        viewModel.addItem(product: ProductType(id: 1, name: "Product A", description: "Description of Product A", image: "productA", price: 10.0), quantity: 1) // Adiciona um produto para visualização
        return ProductDetailView(product: ProductType(id: 1, name: "Product A", description: "Description of Product A", image: "productA", price: 10.0))
            .environmentObject(viewModel) // Passa o ViewModel do Carrinho para a pré-visualização
    }
}
