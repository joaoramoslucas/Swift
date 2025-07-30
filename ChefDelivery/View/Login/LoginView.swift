import SwiftUI
import FirebaseAuth

struct LoginView: View {
    // MUDANÇA 1: Os bindings de isLoggedIn e isAdmin devem vir da view que controla tudo.
    // Se esta é a primeira view, eles podem ser @State. Mas para funcionar
    // com a ContentView, eles precisam ser passados para ela.
    @Binding var isLoggedIn: Bool
    @Binding var isAdmin: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    // MUDANÇA 2: As variáveis de navegação mudaram.
    // 'goToHome' e 'goToStoreRegister' agora controlam o .fullScreenCover
    @State private var goToHome: Bool = false
    @State private var goToStoreRegister: Bool = false
    
    @State private var errorMessage: String? = nil
    @State private var showRegisterView: Bool = false
    
    var body: some View {
        // MUDANÇA 3: O NavigationView foi removido daqui.
        // A navegação para a tela de registro será feita de outra forma.
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("logoLogin")
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
                        
                        NavigationLink("Criar nova conta", destination: RegisterView())
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                    }
                    Spacer()
                }
            }
            .fullScreenCover(isPresented: $goToHome) {
                ContentView(isLoggedIn: isLoggedIn, isAdmin: isAdmin)
            }
            .fullScreenCover(isPresented: $goToStoreRegister) {
                StorageHome()
            }
        }
    }
    
    private func login() {
        errorMessage = nil
        if email.lowercased() == "admgeral@gmail.com" {
            APIService.shared.login(email: email, password: password) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        // Apenas definimos o estado de login
                        self.isAdmin = true
                        self.isLoggedIn = true
                        // E ativamos a navegação
                        self.goToStoreRegister = true
                    }
                case .failure(let error):
                    DispatchQueue.main.async { errorMessage = "Erro no login Admin: \(error.localizedDescription)" }
                }
            }
        } else {
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Erro no login: \(error.localizedDescription)"
                    } else {
                        // Apenas definimos o estado de login
                        self.isAdmin = false
                        self.isLoggedIn = true
                        // E ativamos a navegação
                        self.goToHome = true
                    }
                }
            }
        }
    }
}
