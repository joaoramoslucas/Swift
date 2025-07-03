//
//  StoreType.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/06/23.
//
import Foundation

struct AllStoresTypes: Identifiable, Decodable {
    let id: Int
    let name: String
    let logoImage: String?
    let headerImage: String?
    let location: String
    let products: [ProductType]
    let stars: Int?
    
    enum CodingKeys: String, CodingKey {
            case id, name, location, products, stars
            case logoImage
            case headerImage
        }
}
