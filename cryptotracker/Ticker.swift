//
//  Ticker.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 08/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

// Object to model Ticker data
struct Ticker: Decodable {

  let instrument: Instrument
  var bestAsk: Double
  var bestBid: Double
  var lastPrice: Double
  var currency: String
  var timestamp: Double
  var volume24h: Double
  
}
