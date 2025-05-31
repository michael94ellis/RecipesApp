//
//  AppNavigationManager.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//



import SwiftUI

class AppNavigationManager: ObservableObject {
    
    @Published var navigationPath = NavigationPath()
    
    func navigate(to recipe: Recipe) {
        navigationPath.append(recipe)
    }
    
}
