//
//  CoinImageView.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 13/10/2022.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject var vm: CoinImageViewModel

    init(coin: CoinModel) {
        self._vm = StateObject<CoinImageViewModel>.init(wrappedValue: CoinImageViewModel(coin: coin))
    }
 
    var body: some View {
        ZStack {
            if vm.isLoading == false {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "questionmark")
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await vm.getImage()
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
    }
}
