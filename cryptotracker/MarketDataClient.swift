//
//  MarketDataClient.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 08/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

/// Result of network request
///
/// - success: success
/// - failure: failure
enum Result: Error {
  case success
  case failure(message: String)
}

// Class to make HTTP requests to BTCMarkets.net API
class MarketDataClient {

  /// Enum to specify which endpoint from the client we want
  ///
  /// - tick: endpoint to retrieve ticker for an instrument
  /// - orderbook: endpoint to retrieve orderbook for an instrument
  /// - trades: enpdpoint to retrieve most recent trades for an instrument
  private enum EndpointType: String {
    case tick, orderbook, trades
  }



  // MARK: - Private methods

  private func endpoint(forType type: EndpointType, forInstrument instrument: Instrument, currency: String = "AUD") -> String {
    return "\(Constants.ClientUrls.baseUrl)/\(instrument.rawValue)/\(currency)/\(type.rawValue)"
  }



  // MARK: - Methods

  /// Retrieves the `Ticker` from BTCMarkets.net for a particular instrument
  ///
  /// - Parameters:
  ///   - instrument: the `Instrument` to request `Ticker` for
  ///   - completionHandler: completion handler
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

  /// Retrieves the most recent trades from BTCMarkets.net for a particular instrument
  ///
  /// - Parameters:
  ///   - instrument: the `Instrument` to request most recent trades from
  ///   - completionHandler: completion handler
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

  /// Retrieves the orderbook from BTCMarkets.net for a particular instrument
  ///
  /// - Parameters:
  ///   - instrument: the `Instrument` to request orderbook for
  ///   - completionHandler: completion handler
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

      guard let _ = data else {
        completionHandler(Result.failure(message: "Response is nil"))
        return
      }
    }
  }
  
}
