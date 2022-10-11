//
//  Network Manager.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 10/10/2022.
//

import Foundation

final class NetworkManager {
    
    static func fetch(url: URL) async throws -> Data {
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: url)
            if let response = urlResponse as? HTTPURLResponse, (response.statusCode < 200 || response.statusCode > 300) {
                throw NetworkError.badURLResponse(url: url)
            }
            return data
        }
    }
}

//MARK: - Network Errors
extension NetworkManager {
    enum NetworkError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(let url):
                return "🔥 bad response from url: \(url)"
            case .unknown:
                return "⚠️ an unknown error occured"
            }
        }
    }
}
