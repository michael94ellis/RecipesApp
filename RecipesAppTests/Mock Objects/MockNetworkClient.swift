//
//  MockNetworkClient.swift
//  RecipesApp
//
//  Created by Michael Ellis on 5/31/25.
//

import Foundation
@testable import RecipesApp

class MockNetworkClient: NetworkSession {
    
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError { throw error }
        guard let data = mockData, let response = mockResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
