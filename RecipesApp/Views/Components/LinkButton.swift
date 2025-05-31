//
//  LinkButton.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

struct LinkButton: View {
    let title: String
    let icon: String
    let url: URL
    let color: Color
    
    var body: some View {
        Link(destination: url) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.headline)
            .foregroundColor(color)
            .padding(.vertical, 6)
        }
    }
}
