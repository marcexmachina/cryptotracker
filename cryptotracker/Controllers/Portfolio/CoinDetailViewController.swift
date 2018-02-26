//
//  CoinDetailViewController.swift
//  cryptotracker
//
//  Created by Marc O'Neill on 24/02/2018.
//  Copyright © 2018 marcexmachina. All rights reserved.
//

import UIKit
import CoreData

class CoinDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

  // MARK : - Outlets

  @IBOutlet weak var typeTextField: UITextField!
  @IBOutlet weak var amountTextField: UITextField!


  // MARK: - Actions

  @IBAction func saveButtonPressed(_ sender: Any) {
    guard let instrument = selectedInstrument,
      let amountText = amountTextField.text,
      amountText.count > 0,
      let amount = Double(amountText) else {
        //TODO: ALERT GOES HERE
        print("NOPE")
        return
    }
    do {
      try saveCoin(amount: amount, type: instrument.rawValue)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
      // Another alert here
    }
    self.navigationController?.popViewController(animated: true)
  }

  // MARK: - Private properties

  private var selectedInstrument: Instrument?

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    let pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource = self
    typeTextField.inputView = pickerView
    typeTextField.delegate = self
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    typeTextField.endEditing(true)
    amountTextField.endEditing(true)
    super.touchesBegan(touches, with: event)
  }

  // MARK: - Private methods

  private func saveCoin(amount: Double, type: String) throws {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    // 1
    let managedContext = appDelegate.persistentContainer.viewContext

    // 2
    let entity = NSEntityDescription.entity(forEntityName: "Coin", in: managedContext)!

    let coin = NSManagedObject(entity: entity, insertInto: managedContext)
    // 3
    coin.setValue(amount, forKeyPath: "amount")
    coin.setValue(type, forKeyPath: "type")

    // 4
    try managedContext.save()
  }

  // UIPickerViewDataSource

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return Instrument.allValues[row].fullDisplayName()
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Instrument.allValues.count
  }

  // MARK: - UIPickerViewDelegate

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedInstrument = Instrument.allValues[row]
    typeTextField.text = selectedInstrument!.fullDisplayName()
  }

  // MARK: - UITextFieldDelegate

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return false
  }

}
