//
//  GraphViewController.swift
//  WindmillTestTask
//
//  Created by Alex2 on 5/7/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet var chartView: LineChartView!
    @IBOutlet weak var totalWealthLabelValue: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    
    //MARK: - Vars
    lazy var viewModel: GraphViewModel = {
        return GraphViewModel()
    }()
    
    //MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        commonChartSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initVM()
    }
    
    //MARK: - UI
    private func initUI() {
        totalLabel.isHidden = true
        totalWealthLabelValue.isHidden = true
        chartView.noDataText = "Calculating values"
        spiner.startAnimating()
    }

    //MARK: - CHART setup functions
    private func commonChartSetup() {
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        setupXAxis(xAxis)
        
        let leftAxis = chartView.leftAxis
        setupLeftAxis(leftAxis)
        
        let rightAxis = chartView.rightAxis
        setupRightAxis(rightAxis)
        
        chartView.setExtraOffsets(left: 0, top: 20, right: 0, bottom: 0)
        chartView.extraRightOffset = 15
    }
    
    private func initChartViewWithModel(chartModel: ChartModel) {
        guard chartModel.wealth.count > 0 else { return }
        
        var yVals1 : [ChartDataEntry] = []
        for i in 0...chartModel.wealth.count-1 {
            yVals1.append(ChartDataEntry(x: Double(chartModel.days[i]), y: Double(chartModel.wealth[i])))
        }
        let set1 = LineChartDataSet(values: yVals1, label: "Wealth")
        set1.drawFilledEnabled = true
        setupWealthSet(set1)
        
        
        let data = LineChartData(dataSets: [set1])
        data.setValueTextColor(.blue)
        data.setValueFont(UIFont.systemFont(ofSize: 10, weight: .medium))
        
        chartView.data = data
    }
    
    private func commonInitFor(set: LineChartDataSet) {
        set.axisDependency = .left
        set.setCircleColor(.purple)
        set.lineWidth = 2
        set.circleRadius = 0
        set.drawCircleHoleEnabled = false
        set.drawValuesEnabled = false
        set.mode = .cubicBezier
    }
    
    private func setupWealthSet(_ set: LineChartDataSet) {
        commonInitFor(set: set)
        set.setColor(.purple)
        set.fillColor = .purple
        set.highlightColor = .purple
        set.drawValuesEnabled = false
    }
    
    
    private func setupXAxis(_ xAxis: XAxis) {
        xAxis.labelTextColor = .gray
        xAxis.labelFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        xAxis.drawAxisLineEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.granularityEnabled = true
        xAxis.granularity = 1
        xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return self.viewModel.chartData.dates[Int(index)]
        })
        xAxis.yOffset = 10
    }
    
    private func setupLeftAxis(_ leftAxis: YAxis) {
        leftAxis.labelTextColor = .gray
        leftAxis.zeroLineColor = .clear
        leftAxis.axisLineColor = .clear
        leftAxis.drawZeroLineEnabled = false
        leftAxis.labelFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularityEnabled = false
        leftAxis.spaceBottom = 25.0
    }
    
    private func setupRightAxis(_ rightAxis: YAxis) {
        rightAxis.labelTextColor = .clear
        rightAxis.axisMinimum = 0
        rightAxis.granularityEnabled = false
        rightAxis.labelTextColor = .clear
        rightAxis.drawLabelsEnabled = false
    }

    //MARK: - ViewModel
    private func initVM() {
        
        //Bindings
        viewModel.updateChartClosure = { [weak self] in
            DispatchQueue.main.async {
                if let chartModel = self?.viewModel.chartData {
                    self?.initChartViewWithModel(chartModel: chartModel)
                }
            }
        }
        
        viewModel.updateTotalValueClosure = {[weak self] in
            DispatchQueue.main.async {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.maximumFractionDigits = 2
                self?.totalWealthLabelValue.text = numberFormatter.string(from: NSNumber(value:self?.viewModel.currentValuaition ?? 0.00))
                self?.totalWealthLabelValue.isHidden = false
                self?.totalLabel.isHidden = false
                self?.spiner.stopAnimating()
            }
        }
        
        // prepare data for charts
        DispatchQueue.global(qos: .default).sync {
            self.viewModel.fetchDataForClient()
        }
    }
}
