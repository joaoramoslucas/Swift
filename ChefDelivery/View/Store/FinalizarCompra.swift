////
////  CheckoutView.swift
////  ChefDelivery
////
////  Created by Jao on 24/07/24.
////

import SwiftUI

// Estrutura que representa uma linha de item do carrinho
struct FinalizarCompra: View {
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
