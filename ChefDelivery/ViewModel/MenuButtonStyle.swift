//
//  MenuButtonStyle.swift
//  ChefDelivery
//
//  Created by Joao Lucas on 30/07/25.
//
import SwiftUI

struct MenuButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}
