//
//  StoreHeaderSession.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/07/25.
//
import SwiftUI

struct CartItemRow: View {
    let cartItem: CartItem

    var body: some View {
        HStack(spacing: 10) {
            if let productImageName = cartItem.product.image {
                Image(productImageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 120, height: 120)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(cartItem.product.name).font(.headline)
                Text(cartItem.product.description).foregroundColor(.gray)

                HStack {
                    if let price = cartItem.product.price {
                        Text(price.formatted(.currency(code: "BRL")))
                            .font(.subheadline)
                    } else {
                        Text("Preço não disponível")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    Text("Quant: \(cartItem.quantity)").font(.subheadline)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
