import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)

                        Text("Criar Conta")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Preencha seus dados para começar")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 30)

                    // Form
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.orange)
                                .frame(width: 20)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textContentType(.emailAddress)
                        }
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)

                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.orange)
                                .frame(width: 20)
                            SecureField("Senha", text: $password)
                                .textContentType(.newPassword)
                        }
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)

                        HStack(spacing: 12) {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(.orange)
                                .frame(width: 20)
                            SecureField("Confirmar senha", text: $confirmPassword)
                                .textContentType(.newPassword)
                        }
                        .padding(16)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(14)
                    }
                    .padding(.horizontal, 20)

                    // Error
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }

                    // Button
                    Button(action: register) {
                        HStack {
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Criar Conta")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(isFormValid ? Color.orange : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .disabled(!isFormValid || isLoading)
                    .padding(.horizontal, 20)

                    Button("Já tenho uma conta") { dismiss() }
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password.count >= 6
    }

    private func register() {
        errorMessage = nil
        guard password == confirmPassword else {
            errorMessage = "As senhas não coincidem."; return
        }
        isLoading = true
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { _, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    dismiss()
                }
            }
        }
    }
}
