//
//  CoinRowView.swift
//  Crypto Portfolio
//
//  Created by Marc Boanas on 13/10/2022.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            leftColumn
            Spacer()
            rightColumn
        }
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .padding(.leading, 6)
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6DecimalPlaces())
            Text((coin.priceChangePercentage24H ?? 0).asPercentageString())
                .foregroundColor((coin.priceChangePercentage24H ?? 0) < 0 ? Color.Theme.red : Color.Theme.green)
        }
        .padding(.trailing, 10)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}
