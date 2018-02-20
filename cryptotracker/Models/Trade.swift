//
//  Trade.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 11/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

// Object to model Trade data
struct Trade: Decodable {
  let tid: Double
  let amount: Double
  let price: Double
  let date: Double


  //TODO: - Move this to somewhere more appropriate
  var dateString: String {
    let utcDate = Date(timeIntervalSince1970: date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.short
    dateFormatter.timeZone = TimeZone.current
    let localDate = dateFormatter.string(from: utcDate)
    return localDate
  }

  var timeString: String {
    let utcDate = Date(timeIntervalSince1970: date)
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.short
    dateFormatter.timeZone = TimeZone.current
    let localTime = dateFormatter.string(from: utcDate)

    // Convert to 24 hour
    dateFormatter.dateFormat = "h:mm a"
    let tempDate = dateFormatter.date(from: localTime)
    dateFormatter.dateFormat = "HH:mm"
    let newTime = dateFormatter.string(from: tempDate!)
    return newTime
  }

}
