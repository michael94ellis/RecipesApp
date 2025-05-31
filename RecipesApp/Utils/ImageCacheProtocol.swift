//
//  ImageCacheProtocol.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

protocol ImageCacheProtocol {
    /// Retrieves a cached image from disk or memory
    func cachedImage(for url: String) throws -> UIImage?
    
    /// Stores an image in the cache
    func cacheImage(_ image: UIImage, for url: String) throws
}
