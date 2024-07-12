//
//  StoreType.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/06/23.
//

import Foundation // Importa o framework Foundation para funcionalidades básicas

// Estrutura que representa uma loja, conformando-se ao protocolo Identifiable
struct StoreType: Identifiable {
    let id: Int // Identificador único da loja
    let name: String // Nome da loja
    let logoImage: String // Nome da imagem do logo da loja
    let headerImage: String // Nome da imagem de cabeçalho da loja
    let location: String // Localização da loja
    let stars: Int // Avaliação da loja em estrelas (número inteiro)
    let products: [ProductType] // Lista de produtos disponíveis na loja, representada por um array de ProductType
}
