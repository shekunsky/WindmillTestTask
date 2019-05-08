//
//  AssetValuation.swift
//  WindmillTestTask
//
//  Created by Alex2 on 5/7/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

struct AssetValuation: Decodable {
    let valuationDate: Date?
    let valuationInGBP: Double?
    let valuationInCurrency: Double?
}
