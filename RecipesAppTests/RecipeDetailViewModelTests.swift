//
//  RecipeDetailViewModelTests.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//



@testable import RecipesApp
import Testing
import Foundation
import UIKit

struct RecipeDetailViewModelTests {

    @Test("Recipe Image fetched successfully")
    func successfulRecipeImageFetch() async {
        // It's generally ideal to not hit real servers in unit tests
        let testURL = "https://example.com/image.png"
        let testImage = UIImage(systemName: "star")!
        let mockRecipe = Recipe(cuisine: "", name: "", uuid: "", photoURLLarge: nil, photoURLSmall: testURL, sourceURL: nil, youtubeURL: nil)
        
        let mockNetworkClient = MockNetworkClient()
        let mockCacheManager = MockImageCacheManager(imageStore: [:])
        let viewModel = await RecipeDetailViewModel(recipe: mockRecipe, networkClient: mockNetworkClient, imageCacher: mockCacheManager)
        
        mockNetworkClient.mockData = testImage.pngData()
        mockNetworkClient.mockResponse = HTTPURLResponse(url: URL(string: testURL)!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        
        await viewModel.attemptToLoadImage()
        
        switch await viewModel.viewState {
        case .loadedImage(let image):
            #expect(image != nil)
        case .loadingImage:
            Issue.record(Comment(stringLiteral: "Loading state encountered"))
        case .noImage:
            Issue.record(Comment(stringLiteral: "Invalid state encountered"))
        }
    }

    @Test("Recipe Image fetch failure no connection")
    func failedRecipeImageFetch() async {
        
        let mockNetworkClient = MockNetworkClient()
        let viewModel = await RecipeListViewModel(networkClient: mockNetworkClient)
        
        mockNetworkClient.mockError = URLError(.notConnectedToInternet)

        await viewModel.loadRecipes()
        
        switch await viewModel.viewState {
        case .error(let message):
            #expect(message != nil)
        case .loading:
            Issue.record(Comment(stringLiteral: "Loading state encountered"))
        case .loaded(_):
            Issue.record(Comment(stringLiteral: "Invalid loaded state"))
        }
    }
    
    @Test("Recipes fetched successfully and bad data was found")
    func malformedDataRecipeFetch() async {
        
        let mockNetworkClient = MockNetworkClient()
        let viewModel = await RecipeListViewModel(networkClient: mockNetworkClient)
        
        mockNetworkClient.mockData = Data("Invalid_Data".utf8)
        mockNetworkClient.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)

        await viewModel.loadRecipes()
        
        switch await viewModel.viewState {
        case .error(let message):
            #expect(message != nil)
        case .loading:
            Issue.record(Comment(stringLiteral: "Loading state encountered"))
        case .loaded(_):
            Issue.record(Comment(stringLiteral: "Invalid loaded state"))
        }
    }
}
