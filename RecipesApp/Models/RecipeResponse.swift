//
//  RecipeResponse.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

/// Recipe API Call Response DTO definition expected to be returned from the recipe endpoints
struct RecipeResponse: Codable {
    let recipes: [Recipe]?
}
