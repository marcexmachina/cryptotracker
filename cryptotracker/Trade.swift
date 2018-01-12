//
//  Trade.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 11/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

struct Trade: Decodable {
  let tid: Double
  let amount: Double
  let price: Double
  let date: Double
}
