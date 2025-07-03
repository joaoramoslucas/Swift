import SwiftUI

struct AddProductsView: View {
    @ObservedObject var viewModel: ProductViewModel

    @State private var productName = ""
    @State private var productDescription = ""
    @State private var productPrice = ""
    @State private var productImage: Image? = nil
    @State private var inputImage: UIImage? = nil
    @State private var isImagePickerPresented = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            VStack(spacing: 12) {
                ZStack {
                    if let productImage = productImage {
                        productImage
                            .resizable().scaledToFill().frame(width: 180, height: 180).clipShape(Circle()).shadow(radius: 8)
                    } else {
                        Circle().fill(Color.gray.opacity(0.1)).frame(width: 180, height: 180)
                            .overlay(Image(systemName: "photo.on.rectangle.angled").resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(.gray))
                    }
                }
                Label("Adicionar Foto", systemImage: "folder.badge.plus")
                    .foregroundColor(.blue).font(.subheadline).onTapGesture { isImagePickerPresented = true }
            }
            .padding(.top, 40)

            inputField(title: "Nome do Produto", placeholder: "Digite o nome", text: $productName).padding(.top, 32)
            inputField(title: "Descrição do Produto", placeholder: "Digite a descrição", text: $productDescription).padding(.top, 15)
            inputField(title: "Valor", placeholder: "R$", text: $productPrice, keyboard: .decimalPad).padding(.top, 15)
                .onChange(of: productPrice) { newValue in productPrice = formatCurrency(newValue) }

            Spacer()

            Button { addProduct(); dismiss() } label: {
                Label("Adicionar Produto", systemImage: "plus.circle.fill")
                    .foregroundColor(.white).frame(maxWidth: .infinity).padding()
                    .background(Color.orange).cornerRadius(18).shadow(color: .red.opacity(0.3), radius: 6, x: 0, y: 4)
            }.padding(.horizontal, 24).padding(.bottom, 24)
        }
        .navigationTitle("Adicionar Produto").navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isImagePickerPresented) { ImagePicker(image: $inputImage) }
        .onChange(of: inputImage) { _ in loadImage() }
    }

    private func inputField(title: String, placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            TextField(placeholder, text: text)
                .keyboardType(keyboard).padding().background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
        }
        .padding(.horizontal, 24)
    }

    private func formatCurrency(_ value: String) -> String {
        let digits = value.filter { $0.isNumber }
        let number = (Double(digits) ?? 0) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: number)) ?? "R$ 0,00"
    }

    private func loadImage() {
        guard let inputImage = inputImage else { return }
        productImage = Image(uiImage: inputImage)
    }

    private func addProduct() {
        guard !productName.isEmpty, !productDescription.isEmpty, !productPrice.isEmpty else { return }
        let newProduct = Product(
            id: UUID(), name: productName, description: productDescription, price: productPrice, image: productImage
        )
        viewModel.products.append(newProduct)
        productName = ""; productDescription = ""; productPrice = ""; productImage = nil; inputImage = nil
    }
}
