//
//  Instrument.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 08/02/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

/// Enumerated list of Instruments that the
/// application supports
///
/// - btc: Bitcoin
/// - bch: Bitcoin Cash
/// - eth: Ethereum
/// - ltc: Litecoin
/// - xrp: Ripple
enum Instrument: String, Decodable {
  case btc = "BTC"
  case bch = "BCH"
  case eth = "ETH"
  case ltc = "LTC"
  case xrp = "XRP"

  func displayName() -> String {
    switch self {
    case .btc:
      return "Bitcoin"
    case .bch:
      return "Bitcoin Cash"
    case .eth:
      return "Ethereum"
    case .ltc:
      return "Litecoin"
    case .xrp:
      return "Ripple"
    }
  }
}
