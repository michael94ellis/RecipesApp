//
//  RecipesApp.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

@main
struct RecipesApp: App {
    
    @StateObject private var navigator = AppNavigationManager()
    
    var body: some Scene {
        WindowGroup {
            RecipeListView(viewModel: RecipeListViewModel())
                .environmentObject(navigator)
        }
    }
}
