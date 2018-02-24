//
//  PortfolioViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 20/02/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import CoreData

class PortfolioViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  // MARK: - Outlets

  @IBOutlet weak var collectionView: UICollectionView!

  // MARK : - Private properties

  private var coins: [Coin] = [] {
    didSet {
      collectionView.reloadData()
    }
  }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib(nibName: "PortfolioCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "portfolioCell")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    fetchCoins()
  }

  // MARK: - Private methods

  private func fetchCoins() {
    guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Coin")

    do {
      guard let coins = try managedContext.fetch(fetchRequest) as? [Coin] else {
        return
      }
      self.coins = coins
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
  
  // MARK: - UICollectionViewDelegate

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return coins.count
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
