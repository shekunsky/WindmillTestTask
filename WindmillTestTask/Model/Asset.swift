//
//  Asset.swift
//  WindmillTestTask
//
//  Created by Alex2 on 5/7/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

struct Asset: Decodable {
    let assetType: String?
    let assetDescription: String?
    let currency: String?
    let startingDate: Date?
    let category: String?
    let currentValuation: AssetValuation?
    let historicalValuations: [AssetValuation]?
    
    func endingDate() -> Date? {
        var sortedArray = self.historicalValuations
            sortedArray?.sort(by: { $0.valuationDate!.compare($1.valuationDate!) == .orderedAscending})
        return sortedArray?.last?.valuationDate
    }
}
