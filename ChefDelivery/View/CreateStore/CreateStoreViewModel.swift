import SwiftUI

// MARK: - Create Store ViewModel (Single Responsibility: store creation logic)
final class CreateStoreViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var cnpj: String = ""
    @Published var location: String = ""
    @Published var logoUIImage: UIImage? = nil
    @Published var headerUIImage: UIImage? = nil
    @Published var showLogoPicker: Bool = false
    @Published var showHeaderPicker: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var storeCreated: Bool = false

    private let repository: StoreRepositoryProtocol

    init(repository: StoreRepositoryProtocol = StoreRepository()) {
        self.repository = repository
    }

    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !cnpj.trimmingCharacters(in: .whitespaces).isEmpty &&
        !location.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func createStore() {
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil

        repository.createStore(
            name: name.trimmingCharacters(in: .whitespaces),
            cnpj: cnpj.trimmingCharacters(in: .whitespaces),
            location: location.trimmingCharacters(in: .whitespaces)
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.storeCreated = true
                case .failure:
                    self?.errorMessage = "Erro ao criar loja. Tente novamente."
                }
            }
        }
    }
}
