//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didGetInfo(_ sender: CoinManager, data: CoinViewModel)
    func didGetError(_ error: Error)
}
struct CoinManager {
    var delegate : CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "27730B01-AA90-451F-A70C-8F3E793D02D4"
    var chosenCurrency : String?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    mutating func fetchWith(currency name : String){
        chosenCurrency = name
        if let cc = chosenCurrency {
            let url = "\(baseURL)/\(cc)?apikey=\(apiKey)"
            performRequest(with: url)
        }
    }
    func performRequest(with urlString : String) {
        print(urlString)
        if let url = URL(string : urlString) {
            let sess = URLSession(configuration: .default)
            let task = sess.dataTask(with: url, completionHandler: self.handle)
            task.resume()
        }
    }

    func handle(data : Data?, response: URLResponse?, error: Error?) {
        if error==nil {
            if let safeData = data {
                if let coinData = self.parseJSON(safeData) {
                    self.delegate?.didGetInfo(self, data: coinData)
                }
            }
        } else {
            self.delegate?.didGetError(error!)
        }

    }

    func parseJSON(_ coinData : Data)-> CoinViewModel? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let priceString = String(format: "%.2f",decodedData.rate)
            return CoinViewModel(amount: priceString, currency: self.chosenCurrency!)
        } catch {
            self.delegate?.didGetError(error)
            return nil
        }
    }
}

//MARK : This is where we parse the JSON

struct CoinData : Codable {
    let rate : Double
}
