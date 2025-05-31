//
//  RecipeRequest.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

/// Represents different endpoints that return Recipe DTOs
enum RecipeRequest: HTTPRequestable {
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
}
