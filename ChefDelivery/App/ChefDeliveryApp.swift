//
//  ChefDeliveryApp.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import SwiftUI // Importa o framework SwiftUI para construir a interface do usuário

// Estrutura principal do aplicativo, marcada como o ponto de entrada
@main
struct ChefDeliveryApp: App {
    @State private var isLoggedIn: Bool = false // Variável para controlar o estado de login do usuário

    // Corpo principal do aplicativo
    var body: some Scene {
        WindowGroup { // Agrupa as janelas do aplicativo
            if isLoggedIn { // Verifica se o usuário está logado
                ContentView() // Se logado, exibe a tela principal do aplicativos
                    .environmentObject(CartViewModel()) // Passa o ViewModel do carrinho como objeto de ambiente
            } else {
                LoginView(isLoggedIn: $isLoggedIn) // Se não logado, exibe a tela de login
            }
        }
    }
}
