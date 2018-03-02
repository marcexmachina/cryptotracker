//
//  PortfolioCollectionViewCell.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 20/02/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit

class PortfolioCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var detailView: UIView!
  @IBOutlet weak var valueLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var coinImageView: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func configure(with coin: Coin) {
    detailView.layer.masksToBounds = true
    detailView.layer.cornerRadius = 6
    amountLabel.text = "$\(coin.amount)"
    valueLabel.text = "$0.00"
    coinImageView.image = imageForCoin(coin)
  }

  // Private methods
  private func imageForCoin(_ coin: Coin) -> UIImage {
    switch coin.instrument {
    case .btc:
      return #imageLiteral(resourceName: "bitcoin")
    case .bch:
      return #imageLiteral(resourceName: "bitcoin-cash")
    case .eth:
      return #imageLiteral(resourceName: "ethereum-1")
    case .ltc:
      return #imageLiteral(resourceName: "litecoin")
    case .xrp:
      return #imageLiteral(resourceName: "ripple")
    }
  }
}
