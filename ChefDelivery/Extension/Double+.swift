//
//  Double+.swift
//  ChefDelivery
//
//  Created by Jao on 26/06/24.
//

import Foundation // Importa o framework Foundation para funcionalidades básicas

// Extensão para o tipo Double
extension Double {
    // Função para formatar um número como preço
    func FormatPrice() -> String {
        // Cria uma string formatada com duas casas decimais
        let formatString = String(format: "%.2f", self)
        // Substitui o ponto decimal por vírgula, para formatação de preço
        return formatString.replacingOccurrences(of: ".", with: ",")
    }
}
