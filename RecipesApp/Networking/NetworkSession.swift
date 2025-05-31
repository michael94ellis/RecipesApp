//
//  NetworkSession.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

protocol NetworkSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession { }
