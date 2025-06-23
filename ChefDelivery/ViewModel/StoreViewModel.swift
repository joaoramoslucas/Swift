//
//  StoreViewModel.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 18/06/25.
//

import Foundation

class StoreViewModel: ObservableObject {
    @Published var stores: [StoreType] = []
    
    func loadStores() {
        guard let url = URL(string: "https://seu-servidor.com/api/stores") else {
            print("URL inválida")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Nenhum dado retornado")
                return
            }
            
            do {
                let stores = try JSONDecoder().decode([StoreType].self, from: data)
                DispatchQueue.main.async {
                    self.stores = stores
                }
            } catch {
                print("Erro na decodificação: \(error)")
            }
        }.resume()
    }
}


