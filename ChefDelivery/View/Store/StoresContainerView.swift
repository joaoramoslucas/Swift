//
//  StoresContainerView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 29/05/23.
//

import SwiftUI

struct StoresContainerView: View {
    @ObservedObject var viewModel: StoreViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Lojas")
                .foregroundColor(Color.primary)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 30) {
                if viewModel.stores.isEmpty {
                    Text("Carregando lojas...")
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                } else {
                    ForEach(viewModel.stores) { store in
                        NavigationLink {
                            StoreDetailView(store: store)
                        } label: {
                            StoreItemView(store: store)
                        }
                        .foregroundColor(Color.primary)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .foregroundColor(.black)
        .onAppear {
            viewModel.loadStores()
        }
    }
}
let previewStoreViewModel: StoreViewModel = {
    let viewModel = StoreViewModel()
    viewModel.stores = [
        StoreType(
            id: 1,
            name: "Pizzaria do João",
            logoImage: "pizzaria_logo",
            headerImage: "pizzaria_header",
            location: "Rua das Pizzas, 123",
            stars: 5,
            products: [
                ProductType(
                    id: 1,
                    name: "Pizza Calabresa",
                    description: "Deliciosa pizza de calabresa.",
                    image: "pizza_calabresa",
                    price: 49.99
                )
            ]
        ),
        StoreType(
            id: 2,
            name: "Hamburgueria do Chef",
            logoImage: "hamburgueria_logo",
            headerImage: "hamburgueria_header",
            location: "Av. dos Lanches, 456",
            stars: 4,
            products: [
                ProductType(
                    id: 2,
                    name: "Cheeseburger",
                    description: "Pão, carne, queijo e muito sabor.",
                    image: "cheeseburger",
                    price: 24.90
                )
            ]
        )
    ]
    return viewModel
}()

#Preview {
    StoresContainerView(viewModel: previewStoreViewModel)
}
