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

// Formatter for xAxis min/max labels
class AxisFormatter: IndexAxisValueFormatter {

  let trades: [Trade]
  let maxPrice: Double
  let minPrice: Double

  override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    guard let _ = axis as? XAxis else { return "" }
    let index = Int(value)
    let trade = trades[index]
//    let prices = trades.map { $0.price }

//    let minIndex = prices.index(of: minPrice)
//    let maxIndex = prices.index(of: maxPrice)
//    if index == minIndex {
//      return """
//      \n\(trade.timeString)
//      LOW
//      \(trade.price.currencyDisplayString)
//      """
//    } else if index == maxIndex {
//      return """
//      \n\(trade.timeString)
//      HIGH
//      \(trade.price.currencyDisplayString)
//      """
//    } else
    if index % 5 == 0 {
      return trade.timeString
    }
    return ""
  }

  init(trades: [Trade], maxPrice: Double, minPrice: Double, xValues: [String]) {
    self.trades = trades
    self.maxPrice = maxPrice
    self.minPrice = minPrice
    super.init(values: xValues)
  }

  private func axisString(price: String, time: String, date: String) -> String {
    return """
    \(price)
    \(time)
    \(date)
    """
  }
}

// Class to display the price line graph
class GraphViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet weak var graphView: LineChartView!



  // MARK: - Private variables

  /* 25 trades of the last 500 returned from client.
   Need to limit it to 25 as xAxis can only have a max of 25 possible labels,
   so could end up not having a min/max label which isn't good.
   Limitation of Charts library.
  */
  private var trimmedTrades: [Trade] = [Trade]()

  private var maxPrice: Double = 0.00

  private var minPrice: Double = 0.00



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
      if index % 20 == 0 {
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
    line.valueTextColor = .clear
    //let lineColor = UIColor(red: 42/255, green: 111/255, blue: 1, alpha: 1)
    line.colors = [.clear]
    line.drawCirclesEnabled = false
    line.mode = .cubicBezier
    let data = LineChartData()
    data.addDataSet(line)
    graphView.data = data
    graphView.xAxis.valueFormatter = AxisFormatter(trades: trimmedTrades, maxPrice: maxPrice, minPrice: minPrice, xValues: [String]())
    graphView.notifyDataSetChanged()
    if animate {
      graphView.animate(xAxisDuration: 1.8, easingOption: .linear)
    }

    let blueColor = UIColor(red: 27/255, green: 95/255, blue: 159/255, alpha: 1)
    let gradientColors = [blueColor.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
    let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
    let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
    line.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
    line.drawFilledEnabled = true // Draw the Gradient

    graphView.fitScreen()
  }


  /// Initial setup of the graph
  private func setup() {
    graphView.xAxis.setLabelCount(25, force: true)
    graphView.xAxis.labelFont = .preferredFont(forTextStyle: .footnote)
    graphView.xAxis.labelFont = graphView.xAxis.labelFont.withSize(10)
    graphView.xAxis.labelTextColor = .darkGray
    graphView.drawGridBackgroundEnabled = false
    graphView.xAxis.drawAxisLineEnabled = true
    graphView.xAxis.labelPosition = .bottom
    graphView.xAxis.avoidFirstLastClippingEnabled = true
    graphView.leftAxis.drawAxisLineEnabled = false
    graphView.rightAxis.drawAxisLineEnabled = false
    graphView.xAxis.drawGridLinesEnabled = false
    graphView.leftAxis.drawGridLinesEnabled = false
    graphView.rightAxis.drawGridLinesEnabled = false
    graphView.isUserInteractionEnabled = false
    graphView.legend.form = .none
    graphView.chartDescription = nil
    graphView.xAxis.drawLabelsEnabled = true
    graphView.leftAxis.drawLabelsEnabled = false
    graphView.rightAxis.drawLabelsEnabled = false
  }

}
