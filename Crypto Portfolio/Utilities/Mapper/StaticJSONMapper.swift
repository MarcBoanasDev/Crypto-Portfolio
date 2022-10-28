//
//  StaticJSONMapper.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 12/10/2022.
//

import Foundation

struct StaticJSONMapper {
    static func decode<T: Decodable>(type: T.Type = [CoinModel].self, file: String = "coins") throws -> T {
        guard let path = Bundle.main.url(forResource: file, withExtension: "json") else {
            print("Failed to get contents...")
            throw MappingError.failedToGetContents
        }

        let data = try Data(contentsOf: path)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
    }
}
