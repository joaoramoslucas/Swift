import Foundation
import Alamofire

// MARK: - API Response Models
struct UserLoginResponse: Decodable {
    let message: String?
    let token: String?
}

struct CreateStoreResponse: Decodable {
    let message: String?
    let id: Int?
}

// MARK: - Network Service Implementation
final class APIService: NetworkServiceProtocol {
    static let shared = APIService()
    private let baseURL: String

    private init(baseURL: String = "http://127.0.0.1:8080") {
        self.baseURL = baseURL
    }

    func get<T: Decodable>(_ path: String, responseType: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = baseURL + path
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.logError(url: url, error: error, data: response.data)
                    completion(.failure(error))
                }
            }
    }

    func post<T: Decodable>(_ path: String, parameters: [String: Any], responseType: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = baseURL + path
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    self.logError(url: url, error: error, data: response.data)
                    completion(.failure(error))
                }
            }
    }

    // MARK: - Admin Login (specific endpoint)
    func login(email: String, password: String, completion: @escaping (Result<UserLoginResponse, AFError>) -> Void) {
        let parameters: [String: String] = ["email": email, "password": password]
        post("/administrator/authentication", parameters: parameters, responseType: UserLoginResponse.self, completion: completion)
    }

    // MARK: - Private
    private func logError(url: String, error: AFError, data: Data?) {
        #if DEBUG
        print("🚫 ERRO \(url): \(error)")
        if let data = data, let str = String(data: data, encoding: .utf8) {
            print("🚫 Response: \(str)")
        }
        #endif
    }
}
