//
//  RecipeRequest.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

/// Represents different endpoints that return Recipe DTOs
enum RecipeRequest: HTTPRequestable, CaseIterable {
    var host: AppServiceHost { .recipes }

    case allRecipes
    case malformedData
    case emptyData

    var path: String {
        switch self {
        case .allRecipes:
            return "/recipes.json"
        case .malformedData:
            return "/recipes-malformed.json"
        case .emptyData:
            return "/recipes-empty.json"
        }
    }
    
    /// For Debugging only, this wouldn't always be useful for an HTTP request
    var displayName: String {
        switch self {
        case .allRecipes:
            return "All Recipes"
        case .malformedData:
            return "Malformed Data"
        case .emptyData:
            return "Empty List"
        }
    }
}
