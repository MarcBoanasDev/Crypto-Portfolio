//
//  NetworkingManagerCoinListResponseSuccessMock.swift
//  TrackMyCrypto
//
//  Created by Marc Boanas on 21/10/2022.
//

import Foundation

class NetworkingManagerCoinListResponseSuccessMock: NetworkingManagerImp {
    func request<T>(session: URLSession, _ endPoint: EndPoint, type: T.Type) async throws -> T where T : Decodable {
        return try StaticJSONMapper.decode() as! T
    }
}
