//
//  PortfolioViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 20/02/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation

class PortfolioViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  // MARK: - Outlets

  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: - Lifecycle

  override func viewDidLoad() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib(nibName: "PortfolioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "portfolioCell")
  }
  
  // MARK: - UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "portfolioCell", for: indexPath) as? PortfolioCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.backgroundColor = .clear
    cell.configure()
    return cell
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth = (UIScreen.main.bounds.width / 2) - 4
    return CGSize(width: cellWidth, height: cellWidth)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
}
