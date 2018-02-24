//
//  Coin+CoreDataProperties.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 24/02/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//
//

import Foundation
import CoreData


extension Coin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coin> {
        return NSFetchRequest<Coin>(entityName: "Coin")
    }

    @NSManaged public var amount: Double
    @NSManaged public var type: String

  var instrument: Instrument {
    get {
      return Instrument(rawValue: type)!
    }
    set {
      type = newValue.rawValue
    }
  }

}
