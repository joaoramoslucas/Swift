//
//  ProductType.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/06/23.
//
import Foundation

struct ProductType: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let image: String?
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
            case id, name, description, price
            case image = "image_url"
        }
}

struct CartItem {
    let product: ProductType
    var quantity: Int
    
    var subTotal: Double {
           return Double(quantity) * (product.price ?? 0.0)
       }
}

