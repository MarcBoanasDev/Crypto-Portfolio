//
//  CoinListView.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 11/10/2022.
//

import SwiftUI

struct CoinListView: View {
    
    @EnvironmentObject private var vm: CoinListViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                //MARK: - Background Layer
                Color.Theme.background
                    .ignoresSafeArea()
                
                
                //MARK: - Content Layer
                VStack(spacing: 0) {
                    
                    SearchBarView(searchText: $vm.searchText)
                        .onChange(of: vm.searchText) { _ in
                            vm.filterAndSortCoins()
                        }
                    
                    MarketStatDataView()
                    
                    columnTitles
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ZStack(alignment: .top) {
                            
                            switch vm.viewState {
                            case .loading, .fetching:
                                loadingView
                            case .finished:
                                if vm.filteredCoins.isEmpty {
                                    emptyList
                                } else {
                                    coinList
                                }
                            case .reloading:
                                reloadingView
                            default: EmptyView()
                            }
                        }
                    }
                    .refreshable(action: vm.reloadData)
                }
                .onAppear(perform: { UITableView.appearance().separatorStyle = .none })
                .task {
                    if vm.allCoins.isEmpty {
                        await vm.loadData()
                    }
                }
                .navigationTitle("Track My Crypto")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

private extension CoinListView {
    
    private var loadingView: some View {
        Text("Loading...")
    }
    
    private var reloadingView: some View {
        Text("Reloading...")
    }
    
    private var emptyList: some View {
        Text("No coins :(")
    }
    
    private var coinList: some View {
        
        LazyVStack(alignment: .leading, spacing: 10, pinnedViews: []) {
            
            ForEach(vm.filteredCoins) { coin in
                CoinRowView(coin: coin)
            }
        }
    }
    
    private var columnTitles: some View {
        
        HStack {
            
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(Color.Theme.secondaryText)
        .padding(.horizontal)
        .padding(.vertical)
    }
}

struct CoinListView_Previews: PreviewProvider {
    
    static var previews: some View {
        CoinListView()
            .environmentObject(CoinListViewModel(networkingManager: NetworkingManagerCoinListResponseSuccessMock()))
    }
}
