import SwiftUI

struct RemoteImage: View {
    let url: String?
    var placeholder: String = "photo"
    var width: CGFloat = 50
    var height: CGFloat = 50
    var isCircle: Bool = false
    var cornerRadius: CGFloat = 0

    var body: some View {
        if let urlString = url, let imageURL = URL(string: urlString) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    placeholderView
                case .empty:
                    ProgressView()
                        .frame(width: width, height: height)
                @unknown default:
                    placeholderView
                }
            }
            .frame(width: width, height: height)
            .clipShape(shapeFor())
        } else {
            placeholderView
        }
    }

    private var placeholderView: some View {
        Image(systemName: placeholder)
            .resizable()
            .scaledToFit()
            .frame(width: width * 0.5, height: height * 0.5)
            .foregroundColor(.gray.opacity(0.5))
            .frame(width: width, height: height)
            .background(Color.gray.opacity(0.1))
            .clipShape(shapeFor())
    }

    private func shapeFor() -> some Shape {
        RoundedRectangle(cornerRadius: isCircle ? width / 2 : cornerRadius)
    }
}
