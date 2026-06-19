import SwiftUI

struct StoreItemView: View {
    let store: AllStoresTypes

    var body: some View {
        HStack(spacing: 14) {
            RemoteImage(
                url: store.logoImage,
                placeholder: "storefront",
                width: 56,
                height: 56,
                isCircle: true
            )
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(store.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text(store.location)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                if let stars = store.stars, stars > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<stars, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.orange)
                        }
                        ForEach(0..<(5 - stars), id: \.self) { _ in
                            Image(systemName: "star")
                                .font(.system(size: 10))
                                .foregroundColor(.gray.opacity(0.4))
                        }
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }
}
