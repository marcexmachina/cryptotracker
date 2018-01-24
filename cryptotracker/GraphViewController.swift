//
//  GraphViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 15/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import UIKit

import Charts

class GraphViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet weak var graphView: LineChartView!



  // MARK: - Private variables

  /// 50 trades of the 500 returned from client
  private var trimmedTrades: [Trade] = [Trade]()



  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }



  // MARK: - Methods

  func update(forTrades trades: [Trade]) {
    trimmedTrades.removeAll()
    let sortedTrades = trades.sorted { $0.date < $1.date }
    for (index, element) in sortedTrades.enumerated() {
      if index % 10 == 0 {
        trimmedTrades.append(element)
      }
    }
    updateGraph()
  }



  // MARK: - Private methods

  private func updateGraph() {
    var lineChartEntries = [ChartDataEntry]()
    let prices = trimmedTrades.map { $0.price }
    for (index, price) in prices.enumerated() {
      let entry = ChartDataEntry(x: Double(index), y: price)
      lineChartEntries.append(entry)
    }
    let line = LineChartDataSet(values: lineChartEntries, label: nil)
    line.colors = [.white]
    line.drawCirclesEnabled = false
    line.mode = .cubicBezier
    let data = LineChartData()
    data.addDataSet(line)
    data.setValueTextColor(.clear)
    graphView.data = data
  }

  private func setup() {
    graphView.drawGridBackgroundEnabled = false
    graphView.xAxis.drawAxisLineEnabled = false
    graphView.leftAxis.drawAxisLineEnabled = false
    graphView.rightAxis.drawAxisLineEnabled = false
    graphView.xAxis.drawGridLinesEnabled = false
    graphView.leftAxis.drawGridLinesEnabled = false
    graphView.rightAxis.drawGridLinesEnabled = false
    graphView.isUserInteractionEnabled = false
    graphView.legend.form = .none
    graphView.chartDescription = nil
    graphView.xAxis.drawLabelsEnabled = false
    graphView.leftAxis.drawLabelsEnabled = false
    graphView.rightAxis.drawLabelsEnabled = false
  }

}
