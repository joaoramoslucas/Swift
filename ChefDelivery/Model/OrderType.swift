//
//  OrderType.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import Foundation // Importa o framework Foundation para funcionalidades básicas

// Estrutura que representa um tipo de pedido
struct OrderType: Identifiable, Decodable {
    let id: Int          // Identificador único para cada tipo de pedido
    let name: String     // Nome do tipo de pedido
    let image: String    // Nome da imagem associada ao tipo de pedido
    
}

