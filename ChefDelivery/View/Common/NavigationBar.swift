import SwiftUI

struct NavigationBar: View {
    var onMenuTap: (() -> Void)? = nil
    var onCartTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            if let menuAction = onMenuTap {
                Button(action: menuAction) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("Chef Delivery")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }

            Spacer()

            if let cartAction = onCartTap {
                Button(action: cartAction) {
                    Image(systemName: "bag")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
