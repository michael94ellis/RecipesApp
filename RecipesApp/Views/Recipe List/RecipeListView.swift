//
//  RecipeListView.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @ObservedObject private var viewModel: RecipeListViewModel
    
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
    }
    
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
            RecipeRow(viewModel: .init(recipe: recipe))
        }
        .overlay {
            // Empty list state can be handled in many different ways, this is a simple way
            if recipes.isEmpty {
                emptyListView
            }
        }
        .listStyle(.inset)
        .refreshable {
            Task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    private var emptyListView: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.purple.opacity(0.8))
            
            Text("No recipes available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary.opacity(0.8))
            
            Text("Try pulling down to refresh or tap the button below.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button(action: {
                Task {
                    await viewModel.loadRecipes()
                }
            }) {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.purple.opacity(0.7))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    /// A reusable subview with retry logic for list error/empty states
    @ViewBuilder
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
                        
            Text(message)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.orange)

            Button(action: {
                Task {
                    await viewModel.loadRecipes()
                }
            }) {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.purple.opacity(0.7))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 40)
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

#Preview("Error view") {
    let mockViewModel = RecipeListViewModel()
    mockViewModel.recipeRequest = .malformedData
    return RecipeListView(viewModel: mockViewModel)
}

#Preview("Normal view") {
    // Will access server for data and then use cache
    RecipeListView(viewModel: RecipeListViewModel())
}

#Preview("Empty view") {
    let mockViewModel = RecipeListViewModel()
    mockViewModel.recipeRequest = .emptyData
    return RecipeListView(viewModel: mockViewModel)
}
