import SwiftUI

struct NavigationBar: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Chef Delivery")
            .font(.title)
            .bold()
            .foregroundColor(.red)
            
            Spacer()

            Button(action: {
                /* dasdasd */
            }) {
                Image(systemName: "bell.badge")
                    .font(.title3)
                    .foregroundColor(.red)
            }
        }
    }
}

