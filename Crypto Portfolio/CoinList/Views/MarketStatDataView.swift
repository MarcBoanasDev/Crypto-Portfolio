//
//  MarketStatDataView.swift
//  TrackMyCrypto
//
//  Created by Marc Boanas on 24/10/2022.
//

import SwiftUI

struct MarketStatDataView: View {
    
    @EnvironmentObject var vm: CoinListViewModel
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticsView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .frame(minHeight: 80)
    }
}

struct MarketStatData_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            MarketStatDataView()
                .preferredColorScheme($0)
                .previewLayout(.sizeThatFits)
                .environmentObject(dev.coinListVM)
        }
    }
}
