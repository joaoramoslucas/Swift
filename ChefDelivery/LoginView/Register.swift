import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String? = nil
    @State private var isRegistered: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 30)

                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .foregroundColor(.black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Senha", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .foregroundColor(.black)

                    SecureField("Confirmar Senha", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .foregroundColor(.black)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }

                    Button(action: {
                        register()
                    }) {
                        Text("Criar Conta")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .padding()

                    Button("Já tenho uma conta") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                .padding(.bottom)
            }
        }
    }

    private func register() {
        errorMessage = nil

        guard password == confirmPassword else {
            errorMessage = "As senhas não coincidem."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                print("Erro ao criar conta:", error.localizedDescription)
            } else {
                print("Conta criada com sucesso!")
                dismiss() // volta automaticamente para o LoginView
            }
        }
    }
}
