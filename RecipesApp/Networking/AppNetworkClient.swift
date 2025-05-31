//
//  AppNetworkClient.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation

class AppNetworkClient {
    
    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        return try await session.data(from: url)
    }
}
