import SwiftUI

struct ProductsListView: View {
    @ObservedObject var viewModel: ProductViewModel

    var body: some View {
        VStack {
            if viewModel.products.isEmpty {
                VStack {
                    Image(systemName: "cart.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.5))
                    Text("Nenhum produto adicionado.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            } else {
                List {
                    ForEach(viewModel.products) { product in
                        HStack(spacing: 16) {
                            if let image = product.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    )
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.name)
                                    .font(.headline)
                                Text(product.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(product.price)
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }

                            Spacer()

                            Button {
                                if let index = viewModel.products.firstIndex(where: { $0.id == product.id }) {
                                    viewModel.products.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete(perform: viewModel.removeProduct)
                }
                .listStyle(PlainListStyle())
            }

            NavigationLink(destination: AddProductsView(viewModel: viewModel)) {
                Label("Adicionar Produto", systemImage: "plus.circle.fill")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(18)
                    .shadow(color: .red.opacity(0.3), radius: 6, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .navigationTitle("Meus Produtos")
        .navigationBarTitleDisplayMode(.inline)
    }
}
