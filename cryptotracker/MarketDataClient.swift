//
//  MarketDataClient.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 08/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

enum Result: Error {
  case success
  case failure(message: String)
}

class MarketDataClient {

  private enum EndpointType: String {
    case tick, orderbook, trades
  }

  // MARK: - Private methods

  private func endpoint(forType type: EndpointType, forInstrument instrument: Instrument, currency: String = "AUD") -> String {
    return "\(Constants.ClientUrls.baseUrl)/\(instrument.rawValue)/\(currency)/\(type.rawValue)"
  }


  // MARK: - Methods


  ///
  ///
  /// - Parameters:
  ///   - instrument: <#instrument description#>
  ///   - completionHandler: <#completionHandler description#>
  func ticker(forInstrument instrument: Instrument, completionHandler: @escaping (Ticker?, Result) -> Void) {
    guard let url = URL(string: endpoint(forType: .tick, forInstrument: instrument)) else{
      print("ERROR:: Problem generating URL")
      completionHandler(nil, Result.failure(message: "Problem generating URL"))
      return
    }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard error == nil else {
        completionHandler(nil, Result.failure(message: "Error making network request:: \(error.debugDescription))"))
        return
      }

      guard let data = data else {
        completionHandler(nil, Result.failure(message: "Response is nil"))
        return
      }

      // Decode JSON response
      do {
        let instrumentHistory = try JSONDecoder().decode(Ticker.self, from: data)
        DispatchQueue.main.async {
          completionHandler(instrumentHistory, Result.success)
        }

      } catch let jsonError {
        print(jsonError)
      }
    }.resume()
  }

  /// <#Description#>
  ///
  /// - Parameters:
  ///   - instrument: <#instrument description#>
  ///   - currency: <#currency description#>
  func trades(forInstrument instrument: Instrument, completionHandler: @escaping ([Trade]?, Result) -> Void) {
    guard let url = URL(string: endpoint(forType: .trades, forInstrument: instrument)) else {
      print("ERROR:: Problem generating URL")
      completionHandler(nil, Result.failure(message: "Problem generating URL"))
      return
    }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard error == nil else {
        completionHandler(nil, Result.failure(message: "Error making network request:: \(error.debugDescription))"))
        return
      }

      guard let data = data else {
        completionHandler(nil, Result.failure(message: "Response is nil"))
        return
      }

      // Decode JSON response
      do {
        let trades = try JSONDecoder().decode([Trade].self, from: data)
        DispatchQueue.main.async {
          completionHandler(trades, Result.success)
        }
      } catch let jsonError {
        print(jsonError)
      }
    }.resume()
  }


  /// <#Description#>
  ///
  /// - Parameters:
  ///   - instrument: <#instrument description#>
  ///   - completionHandler: <#completionHandler description#>
  func orderbook(forInstrument instrument: Instrument, completionHandler: @escaping (Result) -> Void) {
    guard let url = URL(string: endpoint(forType: .orderbook, forInstrument: instrument)) else {
      print("ERROR:: Problem generating URL")
      completionHandler(Result.failure(message: "Problem generating URL"))
      return
    }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard error == nil else {
        completionHandler(Result.failure(message: "Error making network request:: \(error.debugDescription))"))
        return
      }

      guard let data = data else {
        completionHandler(Result.failure(message: "Response is nil"))
        return
      }
    }
  }














}
