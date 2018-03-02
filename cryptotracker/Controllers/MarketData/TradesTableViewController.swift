//
//  TradesTableViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 12/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import UIKit

// `UITableViewController` which holds most recent trades on Home screen
class TradesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView?

  // Mark: - Private properties

  private var trades: [Trade] = [Trade]()
  private let refreshController = UIRefreshControl()



  // MARK: - Properties
  
  var instrument: Instrument!
  var marketDataClient: MarketDataClient!



  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.register(UINib(nibName: "TradeCell", bundle: nil), forCellReuseIdentifier: "cell")
    tableView?.refreshControl = refreshController
    refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
  }



  // MARK: - Methods

  func update(forTrades trades: [Trade]) {
    self.trades = trades
    tableView?.reloadData()
  }



  // MARK: - Private methods

  @objc private func refreshData() {
    let notificationInfo: [String: Instrument] = [Constants.UserInfoKeys.instrument: instrument]
    NotificationCenter.default.post(name: .tradesRefreshed, object: nil, userInfo: notificationInfo)
    tableView?.refreshControl?.endRefreshing()
  }

  

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TradeCell
    let trade = trades[indexPath.row]
    cell.configure(forTrade: trade)
    return cell
  }

  

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trades.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}
