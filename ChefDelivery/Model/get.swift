import Foundation

func testarAPIComPayload() {
    guard let url = URL(string: "http://172.19.46.229:8081/administrator/authentication") else {
        print("URL inválida")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // 🔥 Payload (dados que você quer enviar no body)
    let body: [String: Any] = [
        "email": "admgeral@gmail.com",
        "password": "teste123"
    ]

    // Transforma o dicionário em JSON
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    // 🚀 Faz a requisição
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("❌ Erro na requisição: \(error.localizedDescription)")
            return
        }

        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Status Code: \(httpResponse.statusCode)")
        }

        if let data = data {
            do {
                // Tenta converter o JSON de resposta em dicionário
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("✅ Resposta JSON: \(json)")
            } catch {
                // Se não for JSON, imprime como String
                let respostaString = String(data: data, encoding: .utf8) ?? "Resposta inválida"
                print("✅ Resposta: \(respostaString)")
            }
        }
    }.resume()
}
