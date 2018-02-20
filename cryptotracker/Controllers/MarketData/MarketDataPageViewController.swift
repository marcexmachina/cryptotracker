//
//  MarketDataPageViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 12/01/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import Foundation
import UIKit

// UIPageViewController on home screen to display graph and recent trades
class MarketDataPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {


  /// Enum to specify page of PageViewController
  ///
  /// - graph: graph page
  /// - trades: most recent trades page
  private enum Pages: Int {
    case graph, trades
  }



  // MARK: - Private variables

  private var index = 0

  private lazy var marketDataViewControllers: [UIViewController] = {
    var viewControllers = [UIViewController]()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let pageOne = storyboard.instantiateViewController(withIdentifier: "graphpage")
    let pageTwo = storyboard.instantiateViewController(withIdentifier: "tradespage")
    viewControllers.append(pageOne)
    viewControllers.append(pageTwo)
    return viewControllers
  }()



  // MARK: - Variables

  var marketDataClient: MarketDataClient?

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    dataSource = self
    NotificationCenter.default.addObserver(self, selector: #selector(updateInstrument(notification:)), name: .instrumentSelected, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(refresh(notification:)), name: .tradesRefreshed, object: nil)
    setViewControllers([marketDataViewControllers[0]], direction: .reverse, animated: true, completion: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }



  // MARK: - Private methods

  private func trades(forInstrument instrument: Instrument, animate: Bool) {
    guard let marketDataClient = marketDataClient else {
      print("MarketDataPageViewController:: MarketDataClient is nil")
      return
    }

    marketDataClient.trades(forInstrument: instrument) { (trades, result) in
      guard let trades = trades else {
        print("Error retrieving trades:: \(result.localizedDescription)")
        return
      }

      let graphViewController = self.marketDataViewControllers[Pages.graph.rawValue] as! GraphViewController
      let tradesViewController = self.marketDataViewControllers[Pages.trades.rawValue] as! TradesTableViewController
      tradesViewController.instrument = instrument
      tradesViewController.marketDataClient = marketDataClient
      graphViewController.update(forTrades: trades, animate: animate)
      tradesViewController.update(forTrades: trades)
    }
  }



  // MARK: - Notification

  @objc private func updateInstrument(notification: NSNotification) {
    guard let notificationInfo = notification.userInfo as? [String: Instrument], let instrument = notificationInfo[Constants.UserInfoKeys.instrument] else {
      print("Notification Error:: Incorrect UserInfo dictionary")
      return
    }

    trades(forInstrument: instrument, animate: true)
  }

  @objc private func refresh(notification: NSNotification) {
    guard let notificationInfo = notification.userInfo as? [String: Instrument], let instrument = notificationInfo[Constants.UserInfoKeys.instrument] else {
      print("Notification Error:: Incorrect UserInfo dictionary")
      return
    }

    trades(forInstrument: instrument, animate: false)
  }



  // MARK: - UIPageViewControllerDataSource

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = marketDataViewControllers.index(of: viewController) else {
      return nil
    }

    let previousIndex = viewControllerIndex - 1

    guard previousIndex >= 0 else {
      return nil
    }

    guard marketDataViewControllers.count > previousIndex else {
      return nil
    }

    index = previousIndex
    return marketDataViewControllers[previousIndex]
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = marketDataViewControllers.index(of: viewController) else {
      return nil
    }

    let nextIndex = viewControllerIndex + 1
    let viewControllersCount = marketDataViewControllers.count

    guard viewControllersCount != nextIndex else {
      return nil
    }

    guard viewControllersCount > nextIndex else {
      return nil
    }

    index = nextIndex
    return marketDataViewControllers[nextIndex]
  }

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return marketDataViewControllers.count
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return index
  }
  
}
