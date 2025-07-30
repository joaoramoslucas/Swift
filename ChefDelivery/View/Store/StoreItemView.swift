//
//  StoreHeaderSession.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 03/07/25.
//
import SwiftUI

struct StoreItemView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var store: AllStoresTypes
    
    var body: some View {
        HStack {
            if let logoImageName = store.logoImage {
                Image(logoImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            } else {
                Image(systemName: "photo.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text(store.name).font(.headline)
                Text(store.location).font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .background(colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground))
        .cornerRadius(10)
    }
}
