import SwiftUI
import Combine

class OrderTrackingViewModel: ObservableObject {
    @Published var currentStatus: OrderStatus = .confirmed
    @Published var pulseAnimation: Bool = false
    @Published var completedTimes: [Int: String] = [:]
    @Published var orderNumber: String = ""

    private var timer: AnyCancellable?
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    init() {
        orderNumber = String(format: "%06d", Int.random(in: 100000...999999))
    }

    func startTracking() {
        pulseAnimation = true
        completedTimes[0] = dateFormatter.string(from: Date())

        // Simulate progression through stages
        simulateProgress()
    }

    private func simulateProgress() {
        // Stage 1: Preparing (after 8 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            guard let self = self else { return }
            withAnimation(.spring()) {
                self.currentStatus = .preparing
                self.completedTimes[1] = self.dateFormatter.string(from: Date())
            }
        }

        // Stage 2: On the way (after 20 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) { [weak self] in
            guard let self = self else { return }
            withAnimation(.spring()) {
                self.currentStatus = .onTheWay
                self.completedTimes[2] = self.dateFormatter.string(from: Date())
            }
        }

        // Stage 3: Delivered (after 35 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 35) { [weak self] in
            guard let self = self else { return }
            withAnimation(.spring()) {
                self.currentStatus = .delivered
                self.completedTimes[3] = self.dateFormatter.string(from: Date())
                self.pulseAnimation = false
            }
        }
    }
}
