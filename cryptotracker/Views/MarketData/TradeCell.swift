//
//  TradeCell.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 12/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import UIKit

// Custom cell for recent trades in `UIPageViewController` on Home screen
class TradeCell: UITableViewCell {

  // MARK: - Outlets

  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!



  // MARK: - Methods

  func configure(forTrade trade: Trade) {
    dateLabel.text = timeString(date: trade.date)
    amountLabel.text = "\(trade.amount)"
    priceLabel.text = "$\(trade.price.currencyDisplayString)"
    backgroundColor = .clear
  }



  // MARK: - Private Methods

  private func timeString(date: Double) -> String {
    let date = Date(timeIntervalSince1970: date)
    let difference = Date().timeIntervalSince(date)
    let differenceSeconds = Int(difference)
    let isSeconds = differenceSeconds < 60

    if isSeconds {
      let isPlural = differenceSeconds > 1 || differenceSeconds == 0
      if isPlural {
        return "\(differenceSeconds) seconds ago"
      } else {
        return "\(differenceSeconds) second ago"
      }
    } else {
      let minutes = differenceSeconds / 60
      let differenceMinutes = Int(minutes)

      let isPlural = differenceMinutes > 1
      if isPlural {
        return "\(differenceMinutes) minutes ago"
      } else {
        return "\(differenceMinutes) minute ago"
      }
    }
  }
}
