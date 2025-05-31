//
//  AppNetworkClient.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

class AppNetworkClient: NetworkSession {
    
    static let shared = AppNetworkClient()
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        return try await session.data(from: url)
    }
}
