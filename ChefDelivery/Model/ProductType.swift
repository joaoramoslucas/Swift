//
//  ProductType.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/06/23.
//

import Foundation

struct ProductType: Identifiable {
  let id: Int
  let name: String
  let description: String
  let image: String
  let price: Double
    
    var formatPrice: String {
        return "R$" + price.FormatPrice()
    }
}

struct CartItem {
    let product: ProductType
    var quantity: Int
    var subTotal: Double {
        return Double(quantity) * product.price
    }
}
