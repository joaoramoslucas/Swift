//
//  CreditCardView.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 28/05/25.
//
import SwiftUI

struct CreditCardView: View {
    var number: String
    var name: String
    var expiration: String
    var cvv: String
    var isBackVisible: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .shadow(radius: 5)

            if isBackVisible {
                VStack(alignment: .leading, spacing: 16) {
                    Rectangle()
                        .fill(Color.black.opacity(0.8))
                        .frame(height: 40)
                        .padding(.top, 20)

                    HStack {
                        Text("CVV:")
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        Spacer()
                        Text(cvv)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    Text("ChefDelivery Card")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 30)

                    Text(maskedCardNumber)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    HStack {
                        Text("Validade: \(expiration)")
                            .font(.title3)
                        Spacer()
                        Text(name)
                            .font(.title3)
                    }
                    .padding(.top, 30)
                    .foregroundColor(.white)
                    .font(.caption)

                    Spacer()
                }
                .padding()
            }
        }
        .animation(.easeInOut, value: isBackVisible)
    }

    var maskedCardNumber: String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        let masked = cleaned.enumerated().map { index, char in
            return index < cleaned.count - 4 ? "•" : String(char)
        }
        return stride(from: 0, to: masked.count, by: 4).map {
            Array(masked[$0..<min($0 + 4, masked.count)]).joined()
        }.joined(separator: " ")
    }
}
