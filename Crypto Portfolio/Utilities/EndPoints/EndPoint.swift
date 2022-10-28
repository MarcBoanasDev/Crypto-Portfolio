//
//  EndPoint.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 12/10/2022.
//

import Foundation

/* Coin Data
https://api.coingecko.com/api/v3/coins/markets?vs_currency=gbp&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
*/

/* Coin Detail Data
 https://api.coingecko.com/api/v3/coins/coin.id?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
 */

/* Market Data
 https://api.coingecko.com/api/v3/global
 */

enum EndPoint {
    
    case coins(currency: String = "gbp",
               order: String = "market_cap_desc",
               perPage: Int = 250,
               page: Int = 1,
               sparkline: Bool = true,
               priceChangePercentage: String = "24h")
    
    case detail(coinId: String,
                localization: Bool = false,
                tickers: Bool = false,
                market_data: Bool = false,
                community_data: Bool = false,
                developer_data: Bool = false,
                sparkline: Bool = false)
    
    case market
}

extension EndPoint {
    var host: String { "api.coingecko.com" }
    
    var path: String {
        switch self {
        case .coins:
            return "/api/v3/coins/markets"
        case .detail(let coinId, _, _, _, _, _, _):
            return "/api/v3/coins/\(coinId)"
        case .market:
            return "/api/v3/global"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .coins, .detail, .market:
            return .GET
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .coins(let currency, let order, let perPage, let page, let sparkline, let priceChangePercentage):
            return ["vs_currency": "\(currency)", "order": "\(order)", "per_page": "\(perPage)", "page": "\(page)", "sparkline": "\(sparkline)", "price_change_percentage": priceChangePercentage]
        case .detail(_, let localization, let tickers, let market_data, let community_data, let developer_data, let sparkline):
            return ["localization": "\(localization)", "tickers": "\(tickers)", "market_data": "\(market_data)", "community_data": "\(community_data)", "developer_data": "\(developer_data)", "sparkline": "\(sparkline)"]
        case .market: return [:]
        }
    }
}

extension EndPoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}

extension EndPoint {
    
    enum MethodType: Equatable {
        case GET
    }
}
