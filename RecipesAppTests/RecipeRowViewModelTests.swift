//
//  RecipeRowViewModelTests.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Testing
@testable import RecipesApp
import Foundation
import UIKit

struct RecipeRowViewModelTests {
    
    @Test func fetchPreviouslyCachedImage() async throws {
        // It's generally ideal to not hit real servers in unit tests
        let testURL = "https://example.com/image.png"
        let cachedImage = UIImage(systemName: "star")!
        let mockRecipe = Recipe(cuisine: "", name: "", uuid: "", photoURLLarge: nil, photoURLSmall: testURL, sourceURL: nil, youtubeURL: nil)
        
        let mockNetworkClient = MockNetworkClient()
        let mockCacheManager = MockImageCacheManager(imageStore: [:])
        let viewModel = await RecipeRowViewModel(recipe: mockRecipe, networkClient: mockNetworkClient, imageCacher: mockCacheManager)
        
        mockCacheManager.cacheImage(cachedImage, for: testURL)
        
        await viewModel.attemptToLoadImage()
        
        switch await viewModel.viewState {
        case .loadedImage(let image):
            #expect(image == cachedImage)
        case .loadingImage:
            Issue.record(Comment(stringLiteral: "Loading state encountered"))
        case .noImage:
            Issue.record(Comment(stringLiteral: "Invalid state encountered"))
        }
    }
    
    @Test func downloadImageNotInCache() async throws {
        // It's generally ideal to not hit real servers in unit tests
        let testURL = "https://example.com/image.png"
        let testImage = UIImage(systemName: "star")!
        let mockRecipe = Recipe(cuisine: "", name: "", uuid: "", photoURLLarge: nil, photoURLSmall: testURL, sourceURL: nil, youtubeURL: nil)
        
        let mockNetworkClient = MockNetworkClient()
        let mockCacheManager = MockImageCacheManager(imageStore: [:])
        let viewModel = await RecipeRowViewModel(recipe: mockRecipe, networkClient: mockNetworkClient, imageCacher: mockCacheManager)
        
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
    
    @Test func downloadImageFailure() async throws {
        // It's generally ideal to not hit real servers in unit tests
        let testURL = "https://example.com/image.png"
        let testImage = UIImage(systemName: "star")!
        let mockRecipe = Recipe(cuisine: "", name: "", uuid: "", photoURLLarge: nil, photoURLSmall: testURL, sourceURL: nil, youtubeURL: nil)
        
        let mockNetworkClient = MockNetworkClient()
        let mockCacheManager = MockImageCacheManager(imageStore: [:])
        let viewModel = await RecipeRowViewModel(recipe: mockRecipe, networkClient: mockNetworkClient, imageCacher: mockCacheManager)
        
        // Even though an image data is returned, if a 400 is received the request should be handled as a failure in the ViewModel
        mockNetworkClient.mockData = testImage.pngData()
        mockNetworkClient.mockResponse = HTTPURLResponse(url: URL(string: testURL)!,
                                                          statusCode: 400,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        
        await viewModel.attemptToLoadImage()
        
        switch await viewModel.viewState {
        case .loadedImage(_):
            Issue.record(Comment(stringLiteral: "Invalid state encountered"))
        case .loadingImage:
            Issue.record(Comment(stringLiteral: "Loading state encountered"))
        case .noImage:
            #expect(true)
        }
    }
    
    @Test func downloadInvalidImageData() async throws {
        let testURL = "https://example.com/image.png"
        let mockRecipe = Recipe(cuisine: "", name: "", uuid: "", photoURLLarge: nil, photoURLSmall: testURL, sourceURL: nil, youtubeURL: nil)
        
        let mockNetworkClient = MockNetworkClient()
        let mockCacheManager = MockImageCacheManager(imageStore: [:])
        let viewModel = await RecipeRowViewModel(recipe: mockRecipe, networkClient: mockNetworkClient, imageCacher: mockCacheManager)
        
        mockNetworkClient.mockData = Data("Invalid_Data".utf8) // Malformed Data
        mockNetworkClient.mockResponse = HTTPURLResponse(url: URL(string: testURL)!,
                                                          statusCode: 200,
                                                          httpVersion: nil,
                                                          headerFields: nil)
        
        await viewModel.attemptToLoadImage()
        
        switch await viewModel.viewState {
        case .loadedImage(_):
            Issue.record(Comment(stringLiteral: "Invalid state encountered"))
        case .loadingImage:
            Issue.record(Comment(stringLiteral: "Loading state encountered"))
        case .noImage:
            #expect(true)
        }
    }

}
