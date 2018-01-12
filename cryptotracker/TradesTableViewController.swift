//
//  TradesTableViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 12/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import UIKit

class TradesTableViewController: UITableViewController {

  // Mark: - Variables

  private var trades: [Trade] = [Trade]()



  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "TradeCell", bundle: nil), forCellReuseIdentifier: "cell")
  }



  // MARK: - Methods

  func update(forTrades trades: [Trade]) {
    self.trades = trades
    tableView.reloadData()
  }



  // MARK: - UITableViewDataSource

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TradeCell
    let trade = trades[indexPath.row]
    cell.configure(forTrade: trade)
    return cell
  }

  

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trades.count
  }
}
