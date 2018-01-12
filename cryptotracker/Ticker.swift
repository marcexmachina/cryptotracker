//
//  Ticker.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 08/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

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

struct Ticker: Decodable {

  let instrument: Instrument
  var bestAsk: Double
  var bestBid: Double
  var lastPrice: Double
  var currency: String
  var timestamp: Double
  var volume24h: Double

}
