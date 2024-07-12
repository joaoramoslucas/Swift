import SwiftUI // Importa o framework SwiftUI para a criação da interface do usuário

// Estrutura que representa a visualização de detalhes da loja
struct StoreDetailView: View {
    let store: StoreType // Recebe a loja cujos detalhes serão exibidos
    
    var body: some View {
        ScrollView(showsIndicators: false) { // Utiliza um ScrollView para permitir rolagem
            VStack(alignment: .leading) { // Um VStack para empilhar elementos verticalmente
                // Imagem do cabeçalho da loja
                Image(store.headerImage)
                    .resizable() // Permite que a imagem seja redimensionada
                    .scaledToFit() // Escala a imagem para caber no espaço
                
                // HStack para exibir o nome da loja e seu logotipo
                HStack {
                    Text(store.name) // Nome da loja
                        .font(.title) // Define a fonte como título
                        .bold() // Define o texto como negrito
                    
                    Spacer() // Espaçador para empurrar o logotipo para a direita
                    
                    // Imagem do logotipo da loja
                    Image(store.logoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40) // Define o tamanho da imagem
                        .clipShape(Circle()) // Arredonda a imagem em formato circular
                        .shadow(radius: 4) // Adiciona uma sombra à imagem
                }
                .padding(.vertical, 8) // Adiciona preenchimento vertical
                .padding(.horizontal) // Adiciona preenchimento horizontal
                
                // HStack para exibir a localização e a avaliação da loja
                HStack {
                    Text(store.location) // Localização da loja
                    
                    Spacer() // Espaçador
                    
                    // Exibe as estrelas de avaliação da loja
                    ForEach(1...store.stars, id: \.self) { _ in
                        Image(systemName: "star.fill") // Ícone de estrela preenchida
                            .foregroundColor(.yellow) // Define a cor da estrela como amarelo
                            .font(.caption) // Define o tamanho da fonte como pequeno
                    }
                }
                .padding(.vertical, 8) // Adiciona preenchimento vertical
                .padding(.horizontal) // Adiciona preenchimento horizontal
                
                // Itera sobre os produtos da loja
                ForEach(store.products) { product in
                    // Cria um link de navegação para a visualização de detalhes do produto
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductRow(product: product) // Exibe a linha do produto
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove o estilo de botão padrão da navegação
                }
            }
            .navigationTitle(store.name) // Define o título da navegação
            .navigationBarTitleDisplayMode(.inline) // Define o modo de exibição do título
        }
    }
}

// Estrutura que representa uma linha de produto
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
                    .foregroundColor(.black.opacity(0.5)) // Define a cor como um cinza claro
                    .lineLimit(2) // Limita o número de linhas exibidas
                
                Text(product.formatPrice) // Preço do produto formatado
                    .font(.headline) // Define a fonte como título
                    .bold() // Define o texto como negrito
            }
            .padding(.trailing, 8) // Adiciona preenchimento à direita
            
            Spacer() // Espaçador para empurrar o conteúdo para a esquerda
        }
        .padding(.vertical, 8) // Adiciona preenchimento vertical à linha do produto
        .background(Color.white) // Define o fundo como branco
        .cornerRadius(12) // Arredonda os cantos do fundo
        .shadow(color: .black.opacity(0.1), radius: 10, x: 2, y: 4) // Adiciona sombra à linha
        .padding(.horizontal) // Adiciona preenchimento horizontal
    }
}

// Estrutura para pré-visualização do StoreDetailView
struct StoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreDetailView(store: storesMock[0]) // Exibe a pré-visualização da StoreDetailView com a primeira loja mock
    }
}
