//
//  StatisticModel.swift
//  TrackMyCrypto
//
//  Created by Marc Boanas on 24/10/2022.
//

import Foundation

struct StatisticModel: Identifiable, Hashable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
