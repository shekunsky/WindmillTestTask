//
//  GraphViewModel.swift
//  WindmillTestTask
//
//  Created by Alex2 on 5/7/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

struct ChartModel {
    var days: [Int]
    var dates: [String]
    var wealth: [Double]
   
}

struct GraphViewModel {
    
    //MARK: Vars
    var chartData: ChartModel = ChartModel(days:[], dates:[], wealth:[]) {
        didSet {
            self.updateChartClosure?()
        }
    }
    
    var currentValuaition: Double = 0.00 {
        didSet {
            self.updateTotalValueClosure?()
        }
    }
    
    var updateChartClosure: (()->())?
    var updateTotalValueClosure: (()->())?
    
    mutating func fetchDataForClient() {
        let start = Date()
        if let client = fetchData()?.first {
            var startDate = client.startingDateForClient()
            let endDate = client.endingDateForClient()
            let calendar = Calendar.current
            if let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day {
                var weakModel : ChartModel = ChartModel(days:[], dates:[], wealth:[])
                
                for i in  1...numberOfDays {
                    let year = calendar.dateComponents([.year], from: startDate).year
                    let month = calendar.dateComponents([.month], from: startDate).month
                    weakModel.days.append(i-1)
                    weakModel.dates.append("\(month!)/\(year!)")
                    weakModel.wealth.append(client.wealthFor(date: startDate))
                    startDate = calendar.date(byAdding: .day, value: 1, to:startDate)!
                }
                self.chartData = weakModel
                self.currentValuaition = client.currentValuation()
                let end = Date()
                print("complete in \(end.timeIntervalSince(start)) seconds")
            }
        } else {
            //error parsing json data
        }
    }
}
