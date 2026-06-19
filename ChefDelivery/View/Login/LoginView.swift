import SwiftUI

// MARK: - Login View (Single Responsibility: UI only, delegates logic to ViewModel)
struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool
    @StateObject private var viewModel = LoginViewModel()
    @State private var showRegister: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        Spacer().frame(height: 40)
                        logoSection
                        loginCard
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }

    // MARK: - Subviews
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color.orange.opacity(0.9), Color.orange.opacity(0.3), Color(.systemBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var logoSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 50))
                .foregroundColor(.white)
            Text("Chef Delivery")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Seus restaurantes favoritos")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.bottom, 20)
    }

    private var loginCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                formField(icon: "envelope.fill", placeholder: "Email", text: $viewModel.email, keyboard: .emailAddress)
                secureFormField(icon: "lock.fill", placeholder: "Senha", text: $viewModel.password)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            }

            Button(action: performLogin) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Entrar").fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(viewModel.isFormValid ? Color.orange : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .disabled(!viewModel.isFormValid || viewModel.isLoading)

            Button { showRegister = true } label: {
                Text("Não tem conta? ")
                    .foregroundColor(.secondary) +
                Text("Criar agora")
                    .foregroundColor(.orange)
                    .bold()
            }
            .font(.subheadline)
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
    }

    // MARK: - Components
    private func formField(icon: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }

    private func secureFormField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            SecureField(placeholder, text: text)
                .textContentType(.password)
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }

    // MARK: - Actions
    private func performLogin() {
        viewModel.login { success, admin in
            if success {
                isLoggedIn = true
                isAdmin = admin
            }
        }
    }
}
