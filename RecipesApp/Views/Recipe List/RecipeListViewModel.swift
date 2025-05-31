//
//  RecipeListViewModel.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI
import Combine

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
    
    init(networkClient: NetworkSession = URLSession.shared) {
        self.networkClient = networkClient
        Task {
            await loadRecipes()
        }
    }

    func loadRecipes(from url: URL? = RecipeRequest.allRecipes.url) async {

        self.viewState = .loading
        
        guard let url else {
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
        
        let (data, response) = try await networkClient.data(from: url)
        
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
