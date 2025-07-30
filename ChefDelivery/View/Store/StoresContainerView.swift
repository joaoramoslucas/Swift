//
//  StoreHeaderSession.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/07/25.
//
import SwiftUI

struct StoresContainerView: View {
    @ObservedObject var viewModel: StoreViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Lojas")
                .foregroundColor(.red)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(alignment: .leading, spacing: 7) {
                if viewModel.stores.isEmpty {
                    Text("Carregando lojas...").foregroundColor(.gray).padding(.top, 10)
                } else {
                    ForEach(viewModel.stores, id: \.id) { store in
                        NavigationLink {
                            StoreDetailView(store: store)
                        } label: {
                            StoreItemView(store: store)
                                .foregroundColor(.primary)  
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.getAllStores()
        }
    }
}

#Preview {
    StoresContainerView(viewModel: StoreViewModel())
}
