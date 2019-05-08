//
//  Client.swift
//  WindmillTestTask
//
//  Created by Alex2 on 5/7/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

struct Client: Decodable {
    let _id: String?
    let clientName: String?
    let drafts: [Message]?
    let inboxMessages: [Message]?
    let sentItems: [Message]?
    let assets: [Asset]?
    
    func startingDateForClient() -> Date {
        var startDate = Date()
        for asset in assets ?? [] {
            if let date = asset.startingDate,
               date  < startDate {
                startDate = date
            }
        }
        return startDate
    }
    
    func endingDateForClient() -> Date {
        var endDate = startingDateForClient()
        for asset in assets ?? [] {
            if let date = asset.endingDate(),
                date > endDate {
                endDate = date
            }
        }
        return endDate
    }
    
    func wealthFor(date: Date) -> Double {
        var summa = 0.00
        let calendar = NSCalendar.current
        for asset in assets ?? [] {
            if let assetValueForDate = asset.historicalValuations?.filter({ calendar.compare($0.valuationDate!, to: date, toGranularity: .day) == .orderedSame }) {
                summa +=  assetValueForDate.first?.valuationInCurrency ?? 0.00
            }
        }
        return summa
    }
    
    func currentValuation() -> Double {
        var summa = 0.00
        for asset in assets ?? [] {
            summa +=  asset.currentValuation?.valuationInCurrency ?? 0.00
        }
        return summa
    }
}
