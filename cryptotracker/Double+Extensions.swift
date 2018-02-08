//
//  Double+Extensions.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 08/02/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

extension Double {

  /// Formatted `String` representation of a `Double` for currency
  var currencyDisplayString: String {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .currency
    return formatter.string(from: self as NSNumber) ?? "$0.00"
  }

}
