//
//  ProductType.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/06/23.
//

import Foundation // Importa o framework Foundation para funcionalidades básicas

// Estrutura que representa um produto, conformando-se ao protocolo Identifiable
struct ProductType: Identifiable, Decodable {
    let id: Int // Identificador único do produto
    let name: String // Nome do produto
    let description: String // Descrição do produto
    let image: String // Nome da imagem do produto
    let price: Double // Preço do produto
    
    // Computed property que formata o preço para exibição, adicionando o prefixo "R$"
    var formatPrice: String {
        return "R$" + price.FormatPrice() // Chama o método FormatPrice da extensão Double
    }
}

// Estrutura que representa um item no carrinho
struct CartItem {
    let product: ProductType // Produto associado ao item do carrinho
    var quantity: Int // Quantidade do produto no carrinho
    
    // Computed property que calcula o subtotal com base na quantidade e no preço do produto
    var subTotal: Double {
        return Double(quantity) * product.price // Multiplica a quantidade pelo preço do produto
    }
}

