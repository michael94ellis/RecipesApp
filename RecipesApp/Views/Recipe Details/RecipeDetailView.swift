//
//  RecipeDetailView.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @ObservedObject var viewModel: RecipeDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                
                switch viewModel.viewState {
                case .loadingImage:
                    ProgressView()
                        .frame(width: 300, height: 300)
                    
                case .loadedImage(let image):
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                case .noImage:
                    Image(systemName: "fork.knife")
                        .resizable()
                        .foregroundStyle(.purple)
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Text(viewModel.recipe.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Origin: " + viewModel.recipe.cuisine)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Divider()

                if let sourceURL = viewModel.recipe.sourceURL,
                   let url = URL(string: sourceURL) {
                    LinkButton(title: "View Recipe Source",
                         icon: "link.circle.fill",
                         url: url,
                         color: .blue)
                }

                if let youtubeURL = viewModel.recipe.youtubeURL,
                   let url = URL(string: youtubeURL) {
                    LinkButton(title: "Watch on YouTube",
                         icon: "play.rectangle.fill",
                         url: url,
                         color: .orange)
                }
            }
            .padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal, content: {
                Text("Recipe Details")
                    .fontWeight(.bold)
            })
        })
    }
}

