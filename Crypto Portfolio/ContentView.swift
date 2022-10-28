//
//  ContentView.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 10/10/2022.
//

import SwiftUI

struct ContentView: View {
    
    private var coinListVM = CoinListViewModel()
    
    var body: some View {
        TabView {
            CoinListView()
                .environmentObject(coinListVM)
                .tabItem {
                    Image(systemName: "bitcoinsign.circle")
                    Text("Coins")
                }
            Text("Hello")
                .tabItem {
                    Image(systemName: "bitcoinsign.square.fill")
                    Text("Portfolio")
                }
        }
    }
}
