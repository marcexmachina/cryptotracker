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

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func configure() {
    detailView.layer.masksToBounds = true
    detailView.layer.cornerRadius = 6
  }

}
