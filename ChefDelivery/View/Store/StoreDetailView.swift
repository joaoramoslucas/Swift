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
                StoreHeaderSection(store: store) // Nova Subview
                
                Divider()
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                Text("Produtos")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.bottom, 5)

                ForEach(store.products, id: \.id) { product in
                    NavigationLink {
                        ProductDetailView(product: product)
                    } label: {
                        // Nova Subview para o item do produto
                        ProductListItemView(product: product)
                            .foregroundColor(.primary) // Garante cor do texto do link
                    }
                }
            }
        }
        .navigationTitle(store.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
