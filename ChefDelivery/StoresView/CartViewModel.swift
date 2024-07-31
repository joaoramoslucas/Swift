// CartViewModel.swift
// ChefDelivery
//
// Created by Joao Lucas on 29/05/23.

import SwiftUI

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

