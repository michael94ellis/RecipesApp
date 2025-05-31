//
//  NetworkSession.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

protocol NetworkSession {
    func fetchData(from url: URL) async throws -> (Data, URLResponse)
}
