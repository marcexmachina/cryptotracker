//
//  ViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 08/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - Private variables

  private let marketDataClient: MarketDataClient = MarketDataClient()

  private var selectedInstrumentButton: UIButton {
    didSet {
      deselectButton(button: oldValue)
      selectButton(button: selectedInstrumentButton)
    }
  }

  private var notificationInfo: [String: Instrument] = [Constants.UserInfoKeys.instrument: .btc]



  // MARK: - Outlets

  @IBOutlet weak var btcButton: UIButton!
  @IBOutlet weak var bchButton: UIButton!
  @IBOutlet weak var xrpButton: UIButton!
  @IBOutlet weak var ethButton: UIButton!
  @IBOutlet weak var ltcButton: UIButton!
  @IBOutlet weak var lastPriceLabel: UILabel!
  @IBOutlet weak var instrumentPriceLabel: UILabel!



  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.post(name: .instrumentSelected, object: nil, userInfo: notificationInfo)
    tick(forInstrument: .btc)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    selectedInstrumentButton = btcButton
  }

  required init?(coder aDecoder: NSCoder) {
    selectedInstrumentButton = UIButton()
    super.init(coder: aDecoder)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.SegueIdentifiers.marketDataContainerSegue {
      if let destinationVC = segue.destination as? MarketDataPageViewController {
        destinationVC.marketDataClient = marketDataClient
      }
    }
  }


  // Mark: - Actions

  @IBAction func instrumentButtonPressed(sender: AnyObject) {
    guard let button = sender as? UIButton else {
      return
    }

    switch button.tag {
    case 1:
      instrumentButtonSelected(forInstrument: .btc, button: btcButton)
    case 2:
      instrumentButtonSelected(forInstrument: .bch, button: bchButton)
    case 3:
      instrumentButtonSelected(forInstrument: .xrp, button: xrpButton)
    case 4:
      instrumentButtonSelected(forInstrument: .eth, button: ethButton)
    case 5:
      instrumentButtonSelected(forInstrument: .ltc, button: ltcButton)
    default:
      print("Unknown instrument")
    }
  }



  // MARK: - Private Methods

  private func tick(forInstrument instrument: Instrument) {
    marketDataClient.ticker(forInstrument: instrument) { (tick, result) in
      guard let tick = tick else {
        print("No ticker data for \(instrument.displayName())")
        return
      }
      self.lastPriceLabel.text = "AUD\(tick.lastPrice)"
      self.instrumentPriceLabel.text = "\(instrument.displayName()) price"
    }
  }

  private func instrumentButtonSelected(forInstrument instrument: Instrument, button: UIButton) {
    selectedInstrumentButton = button
    tick(forInstrument: instrument)
    notificationInfo[Constants.UserInfoKeys.instrument] = instrument
    NotificationCenter.default.post(name: .instrumentSelected, object: nil, userInfo: notificationInfo)
  }

  private func selectButton(button: UIButton) {
    button.layer.cornerRadius = 6
    let buttonColor = button.backgroundColor
    button.backgroundColor = buttonColor?.withAlphaComponent(0.2)
  }

  private func deselectButton(button: UIButton) {
    let buttonColor = button.backgroundColor
    button.backgroundColor = buttonColor?.withAlphaComponent(0.0)
  }

}

