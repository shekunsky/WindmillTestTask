//
//  WindmillTestTaskTests.swift
//  WindmillTestTaskTests
//
//  Created by Alex2 on 8/26/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import XCTest
@testable import WindmillTestTask

class WindmillTestTaskTests: XCTestCase {

    var sut = GraphViewController()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut.viewModel.fetchDataForClient()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GivenMockData_Result() {
        XCTAssertEqual(sut.viewModel.chartData.days.count, 95)
        XCTAssertEqual(sut.viewModel.currentValuaition, 589898.98815312)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
        }
    }

}
