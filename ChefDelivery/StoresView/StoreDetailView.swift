import SwiftUI

struct StoreDetailView: View {
    let store: StoreType // Recebe a loja cujos detalhes serão exibidos
    @Environment(\.presentationMode) var presentationMode // Para controlar a apresentação do modal
    @State private var isDarkMode: Bool = false
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // Imagem do cabeçalho da loja
                    Image(store.headerImage)
                        .resizable()
                        .scaledToFit()
                    
                    // HStack para exibir o nome da loja e seu logotipo
                    HStack {
                        Text(store.name)
                            .font(.title)
                            .foregroundColor(Color.primary)
                        
                        Spacer()
                        
                        // Imagem do logotipo da loja
                        Image(store.logoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    
                    // HStack para exibir a localização e a avaliação da loja
                    HStack {
                        Text(store.location)
                            .foregroundColor(Color.primary)
                        
                        Spacer()
                        
                        ForEach(1...store.stars, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    
                    // Itera sobre os produtos da loja
                    ForEach(store.products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductRow(product: product)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 20) // Adiciona um padding extra na parte inferior
            }
            .navigationBarTitle(store.name) // Define o título da barra de navegação como o nome da loja
            .navigationBarTitleDisplayMode(.inline) // Exibe o título na mesma linha que o botão "Lojas"
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismissa a tela atual (opcional)
                }) {
                    HStack(spacing: 2) {
                        Image(systemName: "house")
                        Text("Lojas")
                            .bold()
                    }
                    .foregroundColor(.orange) // Cor do texto padrão da barra de navegação
                }
            )
        }
    }

struct ProductRow: View {
    let product: ProductType // Recebe o produto a ser exibido
    
    var body: some View {
        HStack(spacing: 16) { // HStack para empilhar os elementos horizontalmente
            // Imagem do produto
            Image(product.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120) // Define o tamanho da imagem
                .cornerRadius(12) // Arredonda os cantos da imagem
                .shadow(color: .black.opacity(0.1), radius: 10, x: 2, y: 4) // Adiciona sombra
            
            // VStack para exibir informações do produto
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name) // Nome do produto
                    .font(.headline) // Define a fonte como título
                    .bold() // Define o texto como negrito
                
                Text(product.description) // Descrição do produto
                    .font(.subheadline) // Define a fonte como sub-título
                    .foregroundColor(Color.secondary) // Define a cor como um cinza claro
                    .lineLimit(2) // Limita o número de linhas exibidas
                
                Text(product.formatPrice) // Preço do produto formatado
                    .font(.headline) // Define a fonte como título
                    .bold() // Define o texto como negrito
            }
            .padding(.trailing, 8) // Adiciona preenchimento à direita
            
            Spacer() // Espaçador para empurrar o conteúdo para a esquerda
        }
        .padding(.vertical, 8) // Adiciona preenchimento vertical à linha do produto
        .background(Color(UIColor.systemBackground)) // Define o fundo como branco
        .cornerRadius(12) // Arredonda os cantos do fundo
        .shadow(color: .black.opacity(0.1), radius: 10, x: 2, y: 4) // Adiciona sombra à linha
        .padding(.horizontal) // Adiciona preenchimento horizontal
    }
}

struct StoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreDetailView(store: storesMock[0]) // Exibe a pré-visualização da StoreDetailView com a primeira loja mock
    }
}
