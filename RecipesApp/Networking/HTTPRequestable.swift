//
//  HTTPRequestable.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

protocol HTTPRequestable {
    var host: AppServiceHost { get }
    var path: String { get }
}

extension HTTPRequestable {
    var url: URL? {
        guard let url = URL(string: host.rawValue + path) else {
            assertionFailure() // Crash during test/debug if URL is malformed
            return nil
        }
        return url
    }
}
