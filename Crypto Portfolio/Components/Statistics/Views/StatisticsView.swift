//
//  StatisticsView.swift
//  TrackMyCrypto
//
//  Created by Marc Boanas on 24/10/2022.
//

import SwiftUI

struct StatisticsView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.Theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.accentColor)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle.degrees((stat.percentageChange ?? 0.0) < 0 ? 100 : 0))
                Text(stat.percentageChange?.asPercentageString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) < 0 ? Color.Theme.red : Color.Theme.green)
            .opacity(stat.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([dev.marketCap, dev.totalVolume, dev.btcDominance], id: \.self) { stat in
            ForEach(ColorScheme.allCases, id: \.self) {
                StatisticsView(stat: stat)
                    .preferredColorScheme($0)
                    .previewLayout(.sizeThatFits)
            }
        }
    }
}
