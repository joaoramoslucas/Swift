import SwiftUI
import Combine

class OrderTrackingViewModel: ObservableObject {
    @Published var currentStatus: OrderStatus = .confirmed
    @Published var isPulsing: Bool = false
    @Published var completedTimes: [Int: String] = [:]
    @Published var orderNumber: String = ""

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    init() {
        orderNumber = String(format: "%06d", Int.random(in: 100000...999999))
    }

    func startTracking() {
        isPulsing = true
        completedTimes[0] = dateFormatter.string(from: Date())
        simulateProgress()
    }

    private func simulateProgress() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.currentStatus = .preparing
                self.completedTimes[1] = self.dateFormatter.string(from: Date())
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 20) { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.currentStatus = .onTheWay
                self.completedTimes[2] = self.dateFormatter.string(from: Date())
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 35) { [weak self] in
            guard let self = self else { return }
            withAnimation {
                self.currentStatus = .delivered
                self.completedTimes[3] = self.dateFormatter.string(from: Date())
                self.isPulsing = false
            }
        }
    }
}
