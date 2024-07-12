//
//  ContentView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationBar()
                    .padding(.horizontal, 15)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        OrderTypeGridView()
                        CarouselTabView()
                        StoresContainerView()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CartViewModel()
        ContentView()
            .environmentObject(viewModel) // Passa o ViewModel do Carrinho para a pré-visualização
            .previewLayout(.sizeThatFits)
    }
}
