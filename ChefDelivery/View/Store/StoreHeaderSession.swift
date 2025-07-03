//
//  StoreHeaderSession.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/07/25.
//
import SwiftUI

struct StoreHeaderSection: View {
    let store: AllStoresTypes

    var body: some View {
        VStack(alignment: .leading) {
            if let headerImageName = store.headerImage {
                Image(headerImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
            }
            HStack {
                Text(store.name)
                    .font(.title)
                    .foregroundColor(Color.primary)
                Spacer()
                if let logoImageName = store.logoImage {
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                } else {
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
        }
    }
}
