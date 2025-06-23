//
//  StoreRegisterView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 18/06/25.
//

import SwiftUI

struct StorageHome: View {
    @StateObject private var viewModel = ProductViewModel()

    @State private var storeName: String = ""
    @State private var storeCNPJ: String = ""
    @State private var storeImage: Image? = nil
    @State private var inputImage: UIImage? = nil
    @State private var isImagePickerPresented = false

    var body: some View {
            VStack {
                // Foto da Loja
                VStack(spacing: 12) {
                    ZStack {
                        if let storeImage = storeImage {
                            storeImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 180)
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 180, height: 180)
                                .overlay(
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    Label("Adicionar Foto", systemImage: "folder.badge.plus")
                        .foregroundColor(.blue)
                        .font(.subheadline)
                        .onTapGesture { isImagePickerPresented = true }
                }
                .padding(.top, 40)

                // Nome da loja
                inputField(title: "Nome da Loja", placeholder: "Digite o nome da loja", text: $storeName)
                    .padding(.top, 32)

                // CNPJ da loja
                inputField(title: "CNPJ da Loja", placeholder: "Digite o CNPJ", text: $storeCNPJ, keyboard: .numberPad)
                    .padding(.top, 15)

                Spacer()

                NavigationLink(destination: ProductsListView(viewModel: viewModel)) {
                    Text("Informações do Produtos")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(18)
                        .shadow(color: .red.opacity(0.3), radius: 6, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .navigationTitle("Informações da Loja")
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in loadImage() }
        }
    

    private func loadImage() {
        guard let inputImage = inputImage else { return }
        storeImage = Image(uiImage: inputImage)
    }

    private func inputField(title: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            TextField(placeholder, text: text)
                .keyboardType(keyboard)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    StorageHome()
}
