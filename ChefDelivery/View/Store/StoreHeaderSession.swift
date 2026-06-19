import SwiftUI

struct StoreHeaderSection: View {
    let store: AllStoresTypes

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RemoteImage(
                url: store.headerImage,
                placeholder: "storefront.fill",
                width: UIScreen.main.bounds.width,
                height: 200,
                cornerRadius: 0
            )
            .clipped()
            
            .overlay(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            HStack(spacing: 14) {
                RemoteImage(
                    url: store.logoImage,
                    placeholder: "storefront",
                    width: 60,
                    height: 60,
                    isCircle: true
                )
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 4)

                VStack(alignment: .leading, spacing: 4) {
                    Text(store.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(store.location)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))

                    if let stars = store.stars, stars > 0 {
                        HStack(spacing: 3) {
                            ForEach(0..<stars, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.orange)
                            }
                            Text("(\(stars).0)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
            }
            .padding(20)
        }
    }
}
