//
//  HomeViewModel.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 11/10/2022.
//

import SwiftUI
import Combine

final class CoinListViewModel: ObservableObject {
    
    @Published private(set) var allCoins = [CoinModel]()
    @Published private(set) var filteredCoins = [CoinModel]()
    @Published private(set) var marketData: MarketDataModel? = nil
    @Published private(set) var statistics: [StatisticModel] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .rank
    @Published var hasError = false
    
    private var networkingManager: NetworkingManagerImp!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(networkingManager: NetworkingManagerImp = NetworkingManager.shared) {
        self.networkingManager = networkingManager
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        $sortOption
            .combineLatest($allCoins)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterAndSortCoins()
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    @Sendable func loadData(state: ViewState = .loading) async {
        
        reset()
        viewState = state
        await fetchData()
    }
    
    @MainActor
    @Sendable func reloadData() async {
        
        reset()
        viewState = .reloading
        await fetchData()
    }

    @MainActor
    private func fetchData() async {
        
        defer {
            self.viewState = .finished
        }
        
        await fetchCoins()
        await fetchMarketData()
    }

    @MainActor
    private func fetchCoins() async {
        
        do {
            self.allCoins = try await networkingManager.request(session: .shared, .coins(), type: [CoinModel].self)
            print("✅ Fetched coins...")
        } catch {
            handleError(error: error)
        }
    }

    @MainActor
    private func fetchMarketData() async {
        
        do {
            self.marketData = try await networkingManager.request(session: .shared, .market, type: GlobalData.self).data
            print("✅ Fetched market data...")
            self.statistics = mapMarketData(marketData: self.marketData)
        } catch {
            handleError(error: error)
        }
    }
    
    private func handleError(error: Error) {
        
        hasError = true
        
        if let networkingError = error as? NetworkingManager.NetworkingError {
            self.error = networkingError
            print(error.localizedDescription)
        } else {
            self.error = .custom(error: error)
            print(error.localizedDescription)
        }
    }
}

//MARK: - ViewState
extension CoinListViewModel {
    enum ViewState {
        case finished
        case loading
        case reloading
        case fetching
    }
}

//MARK: - Sort Options
extension CoinListViewModel {
    enum SortOption: Equatable {
        case rank, rankReversed, price, priceReversed
    }
}

//MARK: - Filter & Sort Coins
extension CoinListViewModel {
    
    func filterAndSortCoins() {
        var updatedCoins = filterCoins()
        sortCoins(coins: &updatedCoins)
        filteredCoins = updatedCoins
    }
    
    private func sortCoins(coins: inout [CoinModel]) {
        switch sortOption {
        case .rank:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        }
    }
    
    private func filterCoins() -> [CoinModel] {
        guard !searchText.isEmpty else { return allCoins }
        let lowercaseText = searchText.lowercased()
        let filteredCoins = allCoins.filter { coin in
            return coin.name.lowercased().contains(lowercaseText) ||
            coin.symbol.lowercased().contains(lowercaseText) ||
            coin.id.lowercased().contains(lowercaseText)
        }
        return filteredCoins
    }
}

//MARK: - Map Market Data -> StatisticModel
private extension CoinListViewModel {
    
    private func mapMarketData(marketData: MarketDataModel?) -> [StatisticModel] {
        
        var stats: [StatisticModel] = []
        guard let data = marketData else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance
        ])
        
        return stats
    }
}

//MARK: - Reset Method
private extension CoinListViewModel {
    func reset() {
        if viewState == .finished {
            allCoins.removeAll()
            viewState = nil
        }
    }
}
