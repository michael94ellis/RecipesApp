//
//  Recipe.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

/// Recipe list item DTO is expected to contain a list of this object type
struct Recipe: Codable, Hashable {
    let cuisine: String
    let name: String
    let uuid: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case cuisine, name, uuid
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
