import Foundation
import Alamofire

// MARK: - Store Repository (Single Responsibility: data access for stores)
final class StoreRepository: StoreRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = APIService.shared) {
        self.networkService = networkService
    }

    func fetchAllStores(completion: @escaping (Result<[AllStoresTypes], Error>) -> Void) {
        networkService.get("/store/get_all_stores", responseType: [AllStoresTypes].self) { result in
            switch result {
            case .success(let stores):
                completion(.success(stores))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createStore(name: String, cnpj: String, location: String, completion: @escaping (Result<CreateStoreResponse, Error>) -> Void) {
        let parameters: [String: Any] = [
            "name": name,
            "cnpj": cnpj,
            "location": location
        ]
        networkService.post("/store/create_store", parameters: parameters, responseType: CreateStoreResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
