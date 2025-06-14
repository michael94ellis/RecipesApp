//
//  RecipeDetailViewModel.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

@MainActor
class RecipeDetailViewModel: ObservableObject {
    
    enum ViewState {
        case loadingImage
        case loadedImage(UIImage)
        case noImage
    }
    
    /// This should be injected for dependency inversion
    let networkClient: NetworkSession
    /// This should be injected for dependency inversion
    let imageCacheManager: ImageCacheProtocol
    let recipe: Recipe
    
    @Published var viewState: ViewState = .loadingImage
        
    init(recipe: Recipe,
         networkClient: NetworkSession = AppNetworkClient.shared,
         imageCacher: ImageCacheProtocol = ImageCacheManager.shared) {
        self.recipe = recipe
        self.networkClient = networkClient
        self.imageCacheManager = imageCacher
        
        Task {
            await attemptToLoadImage()
        }
    }
    
    func attemptToLoadImage() async {
        if let smallImageURL = recipe.photoURLLarge {
            await fetchImage(for: smallImageURL)
        } else if let largeImageURL = recipe.photoURLSmall {
            await fetchImage(for: largeImageURL)
        } else {
            self.viewState = .noImage
        }
    }
    
    /// Checks for a cached image, if none is found an HTTP call is made to fetch it
    private func fetchImage(for urlString: String) async {
        // Unhandled try, if cache fails then attempt network request to fetch image
        if let cachedImage = try? imageCacheManager.cachedImage(for: urlString) {
            self.viewState = .loadedImage(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            assertionFailure("Invalid or empty URL string for image: \(urlString)")
            self.viewState = .noImage
            return
        }
        do {
            let (data, response) = try await networkClient.fetchData(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                self.viewState = .noImage
                throw URLError(.badServerResponse)
            }
            if let fetchedImage = UIImage(data: data) {
                self.viewState = .loadedImage(fetchedImage)
                try? imageCacheManager.cacheImage(fetchedImage, for: urlString)
            }
        } catch {
            self.viewState = .noImage
            // Non Fatal logging would be great here
            print("Error fetching image from server occurred")
        }
    }
}
