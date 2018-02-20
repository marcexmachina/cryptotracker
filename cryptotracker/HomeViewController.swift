//
//  HomeViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 08/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  // MARK: - Private variables

  private var selectedInstrumentButton: UIButton {
    didSet {
      deselectButton(button: oldValue)
      selectButton(button: selectedInstrumentButton)
    }
  }

  private let marketDataClient: MarketDataClient = MarketDataClient()
  private var notificationInfo: [String: Instrument] = [Constants.UserInfoKeys.instrument: .btc]
  private var selectedInstrument: Instrument = .btc



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
    let _ = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(timerRefresh), userInfo: nil, repeats: true)
    NotificationCenter.default.addObserver(self, selector: #selector(refresh(notification:)), name: .tradesRefreshed, object: nil)
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

  deinit {
    NotificationCenter.default.removeObserver(self)
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
      self.lastPriceLabel.text = tick.lastPrice.currencyDisplayString
      self.instrumentPriceLabel.text = "\(instrument.displayName()) price"
    }
  }

  private func instrumentButtonSelected(forInstrument instrument: Instrument, button: UIButton) {
    selectedInstrumentButton = button
    selectedInstrument = instrument
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

  @objc private func refresh(notification: Notification) {
    guard let notificationInfo = notification.userInfo as? [String: Instrument], let instrument = notificationInfo[Constants.UserInfoKeys.instrument] else {
      print("Notification Error:: Incorrect UserInfo dictionary")
      return
    }

    tick(forInstrument: instrument)
  }

  @objc private func timerRefresh() {
    tick(forInstrument: selectedInstrument)
    notificationInfo[Constants.UserInfoKeys.instrument] = selectedInstrument
    NotificationCenter.default.post(name: .tradesRefreshed, object: nil, userInfo: notificationInfo)
  }

}

