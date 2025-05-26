//
//  LoginViewModel.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 26/05/25.
//

import FirebaseAuth
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?

    func login(completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Erro ao fazer login:", error.localizedDescription)
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                print("Login bem-sucedido!")
                completion(true)
            }
        }
    }
}
