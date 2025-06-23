//
//  product.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 18/06/25.
//

import SwiftUI

struct Product: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: String
    let image: Image?
}

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []

    func removeProduct(at offsets: IndexSet) {
        products.remove(atOffsets: offsets)
    }
}
