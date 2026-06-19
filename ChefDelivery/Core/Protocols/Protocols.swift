import Foundation
import Alamofire

// MARK: - Network Service Protocol (Dependency Inversion)
protocol NetworkServiceProtocol {
    func get<T: Decodable>(_ path: String, responseType: T.Type, completion: @escaping (Result<T, AFError>) -> Void)
    func post<T: Decodable>(_ path: String, parameters: [String: Any], responseType: T.Type, completion: @escaping (Result<T, AFError>) -> Void)
}

// MARK: - Auth Service Protocol (Interface Segregation)
protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<AuthResult, Error>) -> Void)
    func register(email: String, password: String, completion: @escaping (Result<AuthResult, Error>) -> Void)
    func logout()
}

struct AuthResult {
    let userId: String
    let email: String
    let isAdmin: Bool
}

// MARK: - Store Repository Protocol (Single Responsibility)
protocol StoreRepositoryProtocol {
    func fetchAllStores(completion: @escaping (Result<[AllStoresTypes], Error>) -> Void)
    func createStore(name: String, cnpj: String, location: String, completion: @escaping (Result<CreateStoreResponse, Error>) -> Void)
}

// MARK: - Card Storage Protocol (Interface Segregation)
protocol SecureStorageProtocol {
    func save(key: String, data: Data) -> Bool
    func load(key: String) -> Data?
    func delete(key: String)
}
