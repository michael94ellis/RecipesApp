//
//  RecipeListViewModelTests.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

@testable import RecipesApp
import Testing
import Foundation

struct RecipeListViewModelTests {

    @Test("Recipes fetched successfully")
    func successfulRecipeFetch() async {
        
        // Swift testing is async by default, define these values inside each async test case
        let mockNetworkClient = MockNetworkClient()
        let viewModel = await RecipeListViewModel(networkClient: mockNetworkClient)
        
        // String literals are not always ideal, but not a deal breaker for me on writing good tests
        let testRecipes = [Recipe(cuisine: "Italian", name: "Pizza", uuid: "uuid", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)]
        let responseData = try! JSONEncoder().encode(RecipeResponse(recipes: testRecipes))
        
        mockNetworkClient.mockData = responseData
        // It's generally not ideal to hit real servers in unit tests
        mockNetworkClient.mockResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        
        await viewModel.loadRecipes()
        
        
        switch await viewModel.viewState {
        case .error(let message):
            Issue.record(Comment(stringLiteral: message))
        case .loading:
            Issue.record(Comment(stringLiteral: "Loading state encountered"))
        case .loaded(let recipes):
            #expect(recipes.count == 1)
            #expect(recipes.first?.name == "Pizza")
            #expect(recipes.first?.cuisine == "Italian")
            #expect(recipes.first?.uuid == "uuid")
        }
    }

    @Test("Recipes fetch failure")
    func failedRecipeFetch() async {
        
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
        
        mockNetworkClient.mockData = Data("Invalid JSON data of some kind".utf8)
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
