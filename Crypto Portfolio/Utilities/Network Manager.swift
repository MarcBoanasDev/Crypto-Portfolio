//
//  Network Manager.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 10/10/2022.
//

import Foundation
import SwiftUI

protocol NetworkingManagerImp {
    
    func request<T: Decodable>(session: URLSession,
                               _ endPoint: EndPoint,
                               type: T.Type) async throws -> T
}

final class NetworkingManager: NetworkingManagerImp {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    func request<T>(session: URLSession, _ endPoint: EndPoint, type: T.Type) async throws -> T where T: Decodable {
        guard let url = endPoint.url else {
            throw NetworkingError.invalidURL
        }
        
        let request = buildRequest(from: url, methodType: endPoint.methodType)
        let (data, response) = try await session.data(for: request)
        
        try checkResponseIsValid(response)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let res = try decoder.decode(type, from: data)
        
        return res
    }
}

private extension NetworkingManager {
    
    private func buildRequest(from url: URL, methodType: EndPoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        }
        
        return request
    }
    
    private func checkResponseIsValid(_ urlResponse: URLResponse) throws {
        
        guard let response = urlResponse as? HTTPURLResponse, (200...300) ~= response.statusCode else {
            let statusCode = (urlResponse as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode)
        }
    }
}

//MARK: - Network Errors
extension NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case invalidURL
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
        case custom(error: Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "❌ invalid url"
            case .invalidStatusCode(let statusCode):
                return "🔥 bad response from url - status code: \(statusCode)"
            case .invalidData:
                return "🧨 response data is invalid"
            case .failedToDecode(let error):
                return "🛑 failed to decode: \(error.localizedDescription)"
            case .custom(let error):
                return "⚠️ something went wrong: \(error.localizedDescription)"
            }
        }
    }
}
