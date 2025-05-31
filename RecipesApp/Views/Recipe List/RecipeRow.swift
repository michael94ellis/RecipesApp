//
//  RecipeRow.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

struct RecipeRow: View {
    
    @ObservedObject var viewModel: RecipeRowViewModel

    var body: some View {
        HStack(spacing: 24) {
            switch viewModel.viewState {
            case .loadingImage:
                ProgressView()
                    .frame(width: 75, height: 75)
                
            case .loadedImage(let image):
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
            case .noImage:
                Image(systemName: "fork.knife")
                    .resizable()
                    .foregroundStyle(.purple)
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading) {
                Text(viewModel.recipe.name)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(viewModel.recipe.cuisine)
                    .font(.title3)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview("No Image Recipe") {
    let mockRecipeNoImage = Recipe(cuisine: "Italian", name: "Pesto Pizza", uuid: "abc123", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
    RecipeRow(viewModel: .init(recipe: mockRecipeNoImage))
}

#Preview("Bad URL Image") {
    let mockRecipeNoImage = Recipe(cuisine: "Italian", name: "Pesto Pizza", uuid: "abc123", photoURLLarge: nil, photoURLSmall: "badURL", sourceURL: nil, youtubeURL: nil)
    RecipeRow(viewModel: .init(recipe: mockRecipeNoImage))
}
