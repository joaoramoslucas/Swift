import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? = nil
    @State private var showRegisterView: Bool = false

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

                        NavigationLink(destination: RegisterView(), isActive: $showRegisterView) {
                            Button("Criar nova conta") {
                                showRegisterView = true
                            }
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                        }

                        HStack {
                            Button(action: {
                                //
                            }) {
                                Image("imagemGoogle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .background(Color.white)
                                    .cornerRadius(50)
                            }
                            .padding()

                            Button(action: {
                                //
                            }) {
                                Image("imagemFacebook")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .background(Color.white)
                                    .cornerRadius(50)
                            }
                            .padding()

                            Button(action: {
                                //
                            }) {
                                Image("imagemTelefone")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .background(Color.white)
                                    .cornerRadius(50)
                            }
                            .padding()
                        }
                    }

                    Spacer()
                }
            }
        }
    }

    private func login() {
        errorMessage = nil

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                print("Erro no login:", error.localizedDescription)
            } else {
                print("Login realizado com sucesso!")
                DispatchQueue.main.async {
                    isLoggedIn = true
                }
            }
        }
    }
}
