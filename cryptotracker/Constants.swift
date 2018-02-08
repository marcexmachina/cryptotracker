//
//  Constants.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 12/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

// Contains constants to be used within the app
struct Constants {

  struct SegueIdentifiers {
    static let marketDataContainerSegue = "marketDataContainerSegue"
  }

  struct ClientUrls {
    static let baseUrl = "https://api.btcmarkets.net/market"
  }

  struct UserInfoKeys {
    static let instrument = "instrument"
  }
}
