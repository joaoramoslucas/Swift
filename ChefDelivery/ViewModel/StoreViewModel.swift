import Foundation

// MARK: - Store ViewModel (Single Responsibility: presentation logic for stores)
final class StoreViewModel: ObservableObject {
    @Published var stores: [AllStoresTypes] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let repository: StoreRepositoryProtocol

    init(repository: StoreRepositoryProtocol = StoreRepository()) {
        self.repository = repository
    }

    func getAllStores() {
        isLoading = true
        errorMessage = nil

        repository.fetchAllStores { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.stores = data
                case .failure(let error):
                    self?.stores = []
                    self?.errorMessage = "Erro ao carregar lojas"
                    #if DEBUG
                    print("StoreViewModel error: \(error)")
                    #endif
                }
            }
        }
    }
}
