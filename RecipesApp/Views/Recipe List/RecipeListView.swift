//
//  RecipeListView.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.viewState {
                case .loading:
                    ProgressView()
                    
                case .loaded(let recipes):
                    listContentView(recipes)
                
                case .error(let errorMessage):
                    errorView(errorMessage)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Recipes")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func listContentView(_ recipes: [Recipe]) -> some View {
        List(recipes, id: \.uuid) { recipe in
            // TODO: Implement Row View
            Text(recipe.name)
        }
        .overlay {
            // Empty list state can be handled in many different ways, this is a simple way
            if recipes.isEmpty {
                Text("No recipes available.")
            }
        }
        .listStyle(.sidebar)
        .refreshable {
            Task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    /// A reusable subview with retry logic for list error/empty states
    @ViewBuilder
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
                        
            Text(message)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.red)

            Button(action: {
                Task {
                    await viewModel.loadRecipes()
                }
            }, label: {
                Text("Retry")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            .controlSize(.large)
            .padding(.horizontal, 32)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 8)
        )
        .padding(24)
        Spacer()
    }
}
