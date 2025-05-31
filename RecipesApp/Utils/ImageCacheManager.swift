//
//  ImageCacheManager.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import SwiftUI

/// Utility class for managing locally cached images
///
/// Reasoning: Use this to avoid external libraries or `Foundation.URLCache`
class ImageCacheManager: ImageCacheProtocol {
    
    /// Singleton instance for image caching operations
    static let shared = ImageCacheManager()
    
    /// Directory path where cached images are stored
    private let cacheDirectory: URL?
    
    /// Initializes the cache manager, creating a cache directory if necessary
    private init() {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        // This should not fail, in a production app we would add non-fatal logging and assertionFailure().
        // Alternatively we could simply not build our own tool to accomplish an image caching mechanism
        cacheDirectory = paths.first?.appendingPathComponent("ImageCache")
        guard let cacheDirectory else {
            assertionFailure("Failed to init cache directory")
            return
        }
        guard !FileManager.default.fileExists(atPath: cacheDirectory.path) else {
            // Cache already exists
            return
        }
        do {
            try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        } catch {
            assertionFailure("Failed to create cache directory at \(cacheDirectory.path)")
        }
    }

    /// Retrieves a cached image from disk
    func cachedImage(for url: String) throws -> UIImage? {
        guard let fileName = urlToFileName(url) else {
            assertionFailure("Failed to generate filename")
            throw NSError(domain: "Failed to generate filename", code: 101)
        }
        guard let fileURL = cacheDirectory?.appendingPathComponent(fileName) else {
            assertionFailure("Failed to find cache directory")
            throw NSError(domain: "Failed to find cache directory", code: 102)
        }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        }
        return nil
    }

    /// Stores an image in the cache directory
    func cacheImage(_ image: UIImage, for url: String) throws {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            throw NSError(domain: "Failed to convert UIImage to Data", code: 103)
        }
        guard let fileName = urlToFileName(url) else {
            assertionFailure("Failed to generate filename")
            throw NSError(domain: "Failed to generate filename", code: 104)
        }
        guard let fileURL = cacheDirectory?.appendingPathComponent(fileName) else {
            assertionFailure("Failed to find cache directory")
            throw NSError(domain: "Failed to find cache directory", code: 105)
        }
        do {
            try data.write(to: fileURL)
        } catch {
            assertionFailure("Failed to cache image for \(url)")
            throw error
        }
    }

    /// Converts a URL string into a filename-safe format for caching
    private func urlToFileName(_ url: String) -> String? {
        url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    //TODO: Implement func to clear cache
}
