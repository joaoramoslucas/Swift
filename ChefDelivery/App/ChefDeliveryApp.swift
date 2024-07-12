//
//  ChefDeliveryApp.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import SwiftUI

@main
struct ChefDeliveryApp: App {
    @StateObject private var cartViewModel = CartViewModel() // Estado do ambiente para o ViewModel do Carrinho

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cartViewModel) // Passa o ambiente do ViewModel do Carrinho para o ContentView
        }
    }
}
