//
//  StoreViewModel.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 18/06/25.
//
import Foundation
import Alamofire


class StoreViewModel: ObservableObject {
    
    @Published var stores: [AllStoresTypes] = []
    @Published var products: [ProductType] = []
    
    func getAllStores () {
        
        print("AQQQQQQQQQQQQ")
        
        APIService.shared.get("/store/get_all_stores", responseType: [AllStoresTypes].self){ response in
            switch response{
            case .success(let data):
                print("Requisicao feita com sucesso ✅")
                DispatchQueue.main.async {
                    self.stores = data
                }
            case .failure(let err):
                print("Erro ao buscar lojas: \(err)")
                DispatchQueue.main.async {
                    self.stores = []
                }
                
            }
        }
    }
}


