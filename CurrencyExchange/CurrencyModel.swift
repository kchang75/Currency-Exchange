//
//  CurrencyModel.swift
//  CurrencyExchange
//
//  Created by CampusUser on 5/6/17.
//  Copyright © 2017 Kristi Chang. All rights reserved.
//

import Foundation

class Currency {
    
    var _exchangeRateNames = ["CADCAD", "CADCNY", "CADEUR", "CADGBP", "CADJPY", "CADUSD", "CNYCAD", "CNYCNY", "CNYEUR", "CNYGBP", "CNYJPY", "CNYUSD", "EURCAD", "EURCNY", "EUREUR", "EURGBP", "EURJPY", "EURUSD", "GBPCAD", "GBPCNY", "GBPEUR", "GBPGBP", "GBPJPY", "GBPUSD", "JPYCAD", "JPYCNY", "JPYEUR", "JPYGBP", "JPYJPY", "JPYUSD", "USDCAD", "USDCNY", "USDEUR", "USDGBP", "USDJPY", "USDUSD"]
    
    var name : String
    var check : Bool
    var isoCode : String
    var symbol : String
    init(name: String, check: Bool, isoCode: String, symbol : String){
        self.name = name
        self.check = check
        self.isoCode = isoCode
        self.symbol = symbol
    }
    
    class list {
        var currencies = [Currency(name: "US Dollar", check: true, isoCode: "USD", symbol: "\u{0024}"), Currency(name: "British Pound", check: true, isoCode: "GBP", symbol: "\u{00A3}"), Currency(name: "Japanese Yen", check: true, isoCode: "JPY", symbol: "\u{00A5}"), Currency(name: "Canadian Dollar", check: false, isoCode: "CAD", symbol: "\u{0024}"), Currency(name: "Chinese Yuan", check: false, isoCode: "CHY", symbol: "\u{00A5}"),  Currency(name: "Euro", check: false, isoCode: "EUR",symbol: "\u{20AC}")]
    
        static let shared:list = list()
    }
    
}
