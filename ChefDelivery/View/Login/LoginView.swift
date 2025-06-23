import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var isLoggedIn: Bool
    @State var isAdmin: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var goToHome: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showRegisterView: Bool = false
    @State private var goToStoreRegister: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .padding(.bottom, 50)
                    
                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Senha", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                        
                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        Button(action: {
                            login()
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        // ✅ NavigationLink invisível para redirecionar após login
                        NavigationLink(destination: StorageHome(), isActive: $goToStoreRegister) {
                            EmptyView()
                        }
                        NavigationLink(destination: ContentView(), isActive: $goToHome) {
                            ContentView()
                        }
                        .hidden()
                        NavigationLink(destination: RegisterView(), isActive: $showRegisterView) {
                            Button("Criar nova conta") {
                                showRegisterView = true
                            }
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        }

                        
                    }

                    Spacer()
                }
            }
        }
    }

    private func login() {
        errorMessage = nil
        
        // Se for o admin, segue pela API atual
        if email.lowercased() == "admgeral@gmail.com" {
            APIService.shared.login(email: email, password: password) { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        isAdmin = true
                        isLoggedIn = true
                        goToStoreRegister = true
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        errorMessage = "Erro no login: \(error.localizedDescription)"
                    }
                }
            }
        } else {
            // Usuário comum faz login via Firebase
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Erro no login: \(error.localizedDescription)"
                    } else {
                        self.isAdmin = false
                        self.isLoggedIn = true
                        self.goToHome = true
                    }
                }
            }
        }
    }

}
