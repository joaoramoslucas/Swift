// MARK: - APIService.swift
import Foundation
import Alamofire

struct UserLoginResponse: Decodable {
    let message: String?
    let token: String?
}

class APIService {
    static let shared = APIService()
    private let baseURL = "http://127.0.0.1:8080"
    
    private init() {}
    
    func get<T: Decodable>(_ path: String, responseType: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = baseURL + path
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    print("GET para \(url)")
                    completion(.success(value))
                    print("\(value)")
                case .failure(let error):
                    print("🚫 ERRO GET para \(url): \(error)")
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("🚫 Dados brutos do erro: \(str)")
                    }
                    completion(.failure(error))
                }
            }
    }
    func login(email: String, password: String, completion: @escaping (Result<UserLoginResponse, AFError>) -> Void) {
        let url = baseURL + "/administrator/authentication"
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: UserLoginResponse.self) { response in
                switch response.result {
                case .success(let userResponse):
                    print("✅ SUCESSO LOGIN para \(url): \(userResponse.message ?? "Login bem-sucedido")")
//                     if let token = userResponse.token {
//                        UserDefaults.standard.set(token, forKey: "authToken")
//                     }
                    completion(.success(userResponse))
                case .failure(let error):
                    print("🚫 ERRO LOGIN para \(url): \(error)")
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("🚫 Dados brutos do erro: \(str)")
                    }
                    completion(.failure(error))
                }
            }
    }
}
