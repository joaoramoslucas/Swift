import SwiftUI

struct CreateStoreView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CreateStoreViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Store Logo
                    VStack(spacing: 10) {
                        if let image = viewModel.logoUIImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.orange, lineWidth: 3))
                                .shadow(radius: 5)
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.title)
                                        .foregroundColor(.gray)
                                )
                        }

                        Button("Adicionar Logo") {
                            viewModel.showLogoPicker = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    }
                    .padding(.top, 20)

                    // Form Fields
                    VStack(spacing: 16) {
                        FormField(icon: "storefront", placeholder: "Nome da loja", text: $viewModel.name)
                        FormField(icon: "doc.text", placeholder: "CNPJ", text: $viewModel.cnpj, keyboard: .numberPad)
                        FormField(icon: "mappin.and.ellipse", placeholder: "Localização (ex: Rua X, Centro)", text: $viewModel.location)
                    }

                    // Header Image
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Imagem de Capa")
                            .font(.subheadline)
                            .fontWeight(.medium)

                        if let headerImage = viewModel.headerUIImage {
                            Image(uiImage: headerImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Button {
                                viewModel.showHeaderPicker = true
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 150)
                                    .overlay(
                                        VStack(spacing: 8) {
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .font(.title2)
                                            Text("Toque para adicionar")
                                                .font(.caption)
                                        }
                                        .foregroundColor(.gray)
                                    )
                            }
                        }
                    }

                    // Error message
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    // Submit Button
                    Button(action: { viewModel.createStore() }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "plus.circle.fill")
                                Text("Criar Minha Loja")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isFormValid ? Color.orange : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                }
                .padding(20)
            }
            .navigationTitle("Criar Loja")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showLogoPicker) {
                ImagePicker(image: $viewModel.logoUIImage)
            }
            .sheet(isPresented: $viewModel.showHeaderPicker) {
                ImagePicker(image: $viewModel.headerUIImage)
            }
            .alert("Loja Criada!", isPresented: $viewModel.storeCreated) {
                Button("OK") { dismiss() }
            } message: {
                Text("Sua loja foi criada com sucesso! Agora você pode adicionar produtos.")
            }
        }
    }
}

// MARK: - Form Field Component
struct FormField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .keyboardType(keyboard)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
