//
//  NavigationBar.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 17/05/23.
//

import SwiftUI // Importa o framework SwiftUI para criar a interface do usuário

// Estrutura que representa a barra de navegação
struct NavigationBar: View {
    var body: some View {
        HStack { // HStack organiza os elementos horizontalmente
            Spacer() // Adiciona um espaço flexível à esquerda

            // Botão que exibe o endereço
            Text("Chef Delivery")
            .font(.title) // Define o tamanho da fonte
            .bold() // Define o peso da fonte
            .foregroundColor(Color.primary) // Define a cor do texto como preto
            
            Spacer() // Adiciona um espaço flexível à direita

            // Botão que exibe o ícone de notificação
            Button(action: {
                //logica do botao
            }) {
                Image(systemName: "bell.badge") // Ícone de notificação do sistema
                    .font(.title3) // Define o tamanho da fonte do ícone
                    .foregroundColor(.orange) // Define a cor do ícone como vermelho
            }
        }
    }
}
