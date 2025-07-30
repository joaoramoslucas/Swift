//
//  StoreHeaderSession.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/07/25.
//
import SwiftUI

struct StoreDetailView: View {
    let store: AllStoresTypes

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                StoreHeaderSection(store: store)
                
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                Text("Produtos")
                    .font(.headline)
                    .padding(.horizontal)

                if let products = store.products {
                    ForEach(products, id: \.id) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ProductListItemView(product: product)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
        .navigationTitle(store.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
