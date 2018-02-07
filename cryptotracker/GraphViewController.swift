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

class GraphViewController: UIViewController, IValueFormatter {

  // MARK: - Outlets

  @IBOutlet weak var graphView: LineChartView!



  // MARK: - Private variables

  /// 50 trades of the 500 returned from client
  private var trimmedTrades: [Trade] = [Trade]()

  private var maxPrice: Double = 0.00

  private var minPrice: Double = 0.00

  private var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "AUD"
    formatter.currencyGroupingSeparator = ","
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter
  }

  private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
  }



  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }



  // MARK: - Methods

  func update(forTrades trades: [Trade], animate: Bool = true) {
    trimmedTrades.removeAll()
    let sortedTrades = trades.sorted { $0.date < $1.date }
    for (index, element) in sortedTrades.enumerated() {
      if index % 10 == 0 {
        trimmedTrades.append(element)
      }
    }
    updateGraph(animate: animate)
  }



  // MARK: - Private methods

  private func updateGraph(animate: Bool = true) {
    var lineChartEntries = [ChartDataEntry]()
    let prices = trimmedTrades.map { $0.price }

    if let min = prices.min(), let max = prices.max() {
      minPrice = min
      maxPrice = max
    }

    for (index, price) in prices.enumerated() {
      let entry = ChartDataEntry(x: Double(index), y: price)
      lineChartEntries.append(entry)
    }
    let line = LineChartDataSet(values: lineChartEntries, label: nil)
    line.valueFormatter = self
    line.colors = [.white]
    line.drawCirclesEnabled = false
    line.mode = .cubicBezier
    let data = LineChartData()
    data.addDataSet(line)
    graphView.data = data
    graphView.notifyDataSetChanged()
    if animate {
      graphView.animate(xAxisDuration: 1.8, easingOption: .linear)
    }
  }

  private func setup() {
    graphView.drawGridBackgroundEnabled = false
    graphView.xAxis.drawAxisLineEnabled = true
    graphView.xAxis.labelPosition = .bottom
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

  private func localDateTimeFromTimestamp(date: String) -> String {
    print("DATE:: \(date)")
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .short
    dateFormatter.dateStyle = .short
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    let date = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "h:mm a"

    return dateFormatter.string(from: date!)
  }


  // MARK: - IValueFormatter

  func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
    if value == minPrice || value == maxPrice {
      let tradeDateInterval = trimmedTrades[Int(entry.x)].date
      let tradeDate = Date(timeIntervalSince1970: tradeDateInterval)
      let formattedTradeDate = localDateTimeFromTimestamp(date: dateFormatter.string(from: tradeDate))
      let formattedPrice = numberFormatter.string(from: NSNumber(value: value)) ?? ""
      return "\(formattedPrice) \(formattedTradeDate)"
    }
    return ""
  }

}
