//
//  ApiService.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 18/06/25.
//

import Foundation

// MARK: - API Configuration

struct APIConfig {
    static let baseURL = "https://d521-177-129-4-51.ngrok-free.app"

    struct Administrator {
        static let login = "/administrator/authentication"
        static let register = "/administrator/register"
    }

    struct Store {
        static let fetchAll = "/stores"
        static let create = "/stores/create"
    }

    struct Products {
        static let fetch = "/products"
        static let create = "/products/create"
    }

    struct Orders {
        static let fetchAll = "/orders"
        static let updateStatus = "/orders/update"
    }

    /// Retorna a URL completa concatenando a base com o path
    static func fullURL(for path: String) -> String {
        return baseURL + path
    }
}

// MARK: - API Service

class APIService {
    static let shared = APIService()
    private init() {}

    // MARK: - Autenticação

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: APIConfig.fullURL(for: APIConfig.Administrator.login)) else {
            completion(.failure(NSError(domain: "URL inválida", code: 0)))
            return
        }

        let loginData = [
            "email": email,
            "password": password
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: loginData) else {
            completion(.failure(NSError(domain: "Erro ao preparar os dados", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Resposta vazia da API", code: 0)))
                }
                return
            }

            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // MARK: - Lojas

    func fetchStores(completion: @escaping ([StoreType]) -> Void) {
        guard let url = URL(string: APIConfig.fullURL(for: APIConfig.Store.fetchAll)) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let stores = try JSONDecoder().decode([StoreType].self, from: data)
                    DispatchQueue.main.async {
                        completion(stores)
                    }
                } catch {
                    print("❌ Erro no decode: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("❌ Erro na requisição: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Adicione os outros métodos (produtos, pedidos, etc.) com base no mesmo padrão.
}
