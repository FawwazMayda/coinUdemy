//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    @IBOutlet weak var pickerView: UIPickerView!

    var coinManager = CoinManager()
    override func viewDidLoad() {
   
        super.viewDidLoad()
        coinManager.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
}

extension ViewController : UIPickerViewDelegate,UIPickerViewDataSource {
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }

     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        print(selectedCurrency)
        coinManager.fetchWith(currency: selectedCurrency)
    }
}

extension ViewController: CoinManagerDelegate {
    func didGetError(_ error: Error) {
        print(error)
    }
    
    func didGetInfo(_ sender: CoinManager, data: CoinViewModel) {
        DispatchQueue.main.async {
            print("DAPAT DATA???")
            self.amount.text = data.amount
            self.currencyLabel.text = data.currency
        }
    }
}
