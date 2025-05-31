//
//  MockImageCacheManager.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import UIKit
@testable import RecipesApp

class MockImageCacheManager: ImageCacheProtocol {
    
    private var imageStore: [String: UIImage] = [:]
    
    init(imageStore: [String : UIImage]) {
        self.imageStore = imageStore
    }
    
    func cachedImage(for url: String) -> UIImage? {
        return imageStore[url]
    }
    
    func cacheImage(_ image: UIImage, for url: String) {
        imageStore[url] = image
    }
}
