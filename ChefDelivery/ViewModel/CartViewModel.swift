// CartViewModel.swift
// ChefDelivery
//
// Created by Joao Lucas on 29/05/23.

import SwiftUI

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    
    func addItem(product: ProductType, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += quantity
        } else {
            let cartItem = CartItem(product: product, quantity: quantity)
            items.append(cartItem)
        }
    }
    
    func increaseQuantity(at index: Int) {
        items[index].quantity += 1
    }

    func decreaseQuantity(at index: Int) {
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }

    func removeItem(at index: Int) {
        items.remove(at: index)
    }
    
    func removeAll() {
        items.removeAll()
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.subTotal }
    }
}
