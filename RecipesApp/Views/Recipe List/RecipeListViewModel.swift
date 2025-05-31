//
//  RecipeListViewModel.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    
    /// This should be injected for dependency inversion
    let networkClient: NetworkSession
    
    enum ViewState {
        case loading
        case loaded([Recipe])
        case error(String)
    }
    
    @Published var viewState: ViewState = .loading
    
    #if DEBUG
    /// DEBUG ONLY: This would only be used for making previews and ought to handled in a way that doesn't litter the codebase with Debug Macros which slow down build time
    /// Tradeoff - I used a debug macro to make other network request variants accessible
    var recipeRequest: RecipeRequest = .allRecipes
    #else
    let recipeRequest: RecipeRequest = .allRecipes
    #endif
    
    /// Using Dependency Injection would be cleaner and easier for testing and previews
    init(networkClient: NetworkSession = AppNetworkClient()) {
        self.networkClient = networkClient
        Task {
            await loadRecipes()
        }
    }

    func loadRecipes() async {

        self.viewState = .loading
        
        guard let url = recipeRequest.url else {
            // This should not happen, crash in debug builds
            assertionFailure("Invalid URL")
            // Generic error message to not alarm the user
            self.viewState = .error("Something went wrong. Please try again later.")
            return
        }
        
        do {
            let fetchedRecipes = try await fetchRecipes(from: url)
            self.viewState = .loaded(fetchedRecipes)
        } catch {
            self.viewState = .error("Failed to load recipes. Please try again later.")
        }
    }

    /// URL param is expected to be from `RecipeRequest` enum
    private func fetchRecipes(from url: URL) async throws -> [Recipe] {
        
        let (data, response) = try await networkClient.fetchData(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            guard let recipes = decodedResponse.recipes else {
                throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Malformed data"])
            }
            return recipes
        } catch {
            throw error
        }
    }
}
