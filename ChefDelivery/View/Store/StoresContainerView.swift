import SwiftUI

struct StoresContainerView: View {
    @ObservedObject var viewModel: StoreViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Lojas")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("perto de você")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)

            if viewModel.stores.isEmpty {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Carregando lojas...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.stores, id: \.id) { store in
                        NavigationLink {
                            StoreDetailView(store: store)
                        } label: {
                            StoreItemView(store: store)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            if viewModel.stores.isEmpty {
                viewModel.getAllStores()
            }
        }
    }
}

#Preview {
    StoresContainerView(viewModel: StoreViewModel())
}
