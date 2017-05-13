//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by CampusUser on 5/4/17.
//  Copyright © 2017 Kristi Chang. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

    // MARK: outlets
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var convertTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: variables
    var currencies = Currency.list.shared.currencies
    
    var domesticCurrency:String = ""
    var foreignCurrency:String = ""
    
    var domesticCurrencyArray:[String] = [""]
    var foreignCurrencyArray:[String] = [""]
    
    var currency = [String]()
    var currencyDict = [String:String]()
    
    override func viewDidLoad() {
       
        for i in currencies {
            if i.check == true {
                currency.append(i.name)
            }
        }
        
        super.viewDidLoad()
        
        currencyDict = getData()
        
        
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        convertTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Picker Functions
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0) {
            return domesticCurrencyArray[row]
        }
        else {
            return foreignCurrencyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return self.domesticCurrencyArray.count
        }
        else {
            return self.foreignCurrencyArray.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0) {
            switch(row) {
            case 0:
                self.domesticCurrency = domesticCurrencyArray[row]
            case 1:
                self.domesticCurrency = domesticCurrencyArray[row]
            case 2:
                self.domesticCurrency = domesticCurrencyArray[row]
            default:
                self.domesticCurrency = domesticCurrencyArray[row]
            }
        }
        if(component == 1) {
            switch(row) {
            case 0:
                self.foreignCurrency = foreignCurrencyArray[row]
            case 1:
                self.foreignCurrency = foreignCurrencyArray[row]
            case 2:
                self.foreignCurrency = foreignCurrencyArray[row]
            default:
                self.foreignCurrency = foreignCurrencyArray[row]
            }
        }
    
    }
    
    // MARK: USER Functions
    
    func getData() -> Dictionary<String,String> {
        let myYQL = YQL()
        let queryString = "select * from yahoo.finance.xchange where pair in (\"CADCAD\", \"CADCNY\", \"CADEUR\", \"CADGBP\", \"CADJPY\", \"CADUSD\", \"CNYCAD\", \"CNYCNY\", \"CNYEUR\", \"CNYGBP\", \"CNYJPY\", \"CNYUSD\", \"EURCAD\", \"EURCNY\", \"EUREUR\", \"EURGBP\", \"EURJPY\", \"EURUSD\", \"GBPCAD\", \"GBPCNY\", \"GBPEUR\", \"GBPGBP\", \"GBPJPY\", \"GBPUSD\", \"JPYCAD\", \"JPYCNY\", \"JPYEUR\", \"JPYGBP\", \"JPYJPY\", \"JPYUSD\", \"USDCAD\", \"USDCNY\", \"USDEUR\", \"USDGBP\", \"USDJPY\", \"USDUSD\")"
        
        var currencyDict = [String:String]()
        
        // Network session is asyncronous so use a closure to act upon data once data is returned
        myYQL.query(queryString) { jsonDict in
            // With the resulting jsonDict, pull values out
            // jsonDict["query"] results in an Any? object
            // to extract data, cast to a new dictionary (or other data type)
            // repeat this process to pull out more specific information
            let queryDict = jsonDict["query"] as! [String: Any]
            let resultsDict = queryDict["results"] as! [String: Any]
            let rateArray = resultsDict["rate"] as! [Any]
            for i in 0..<rateArray.count {
                let rateDict = rateArray[i] as! [String: Any]
                let name = rateDict["id"] as! String
                let rate = rateDict["Rate"] as! String
                currencyDict.updateValue(rate, forKey: name)
                
            }
        }
        return currencyDict
    }
    
    func handleSwipe(_ sender: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "Currency", sender: self)
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        // unwind
    }
    
    @IBAction func ConvertButton(_ sender: Any) {
        var foreignValue: Float
        let domForString = domesticCurrency + foreignCurrency
        
        if(convertTextField.text! != "") {
            let domesticValue = removeSpecialCharsFromString(convertTextField.text!)
            if(domesticValue != "") {
                foreignValue = Float(domesticValue)!
                let rate: Float = Float(currencyDict[domForString]!)!
                foreignValue = foreignValue * rate
                
                let foreignValueString = String.localizedStringWithFormat("%.2f %@",foreignValue,"")
                
                let hSymbol = getSymbol(domesticCurrency)
                let fSymbol = getSymbol(foreignCurrency)
                resultLabel.text! = hSymbol + "\(domesticValue)" + fSymbol + foreignValueString
            }
            else{
                convertTextField.text! = "Invalid Entry"
                resultLabel.text! = "Enter a valid value to be converted"
            }
        }
        else {
            convertTextField.text! = ""
            resultLabel.text! = "Enter a value to be converted"
        }
    }

    //remove invalid characters (eg non-numerical)
    func removeSpecialCharsFromString(_ text: String) -> String {
        let validChars : Set<Character> = Set("0123456789".characters)
        return String(text.characters.filter {validChars.contains($0) })
    }

    func getSymbol(_ currency:String) -> String {
        switch currency {
            case "CAD":
                return "$"
            case "CNY":
                return "¥"
            case "EUR":
                return "€"
            case "JPY":
                return "¥"
            case "GBP":
                return "£"
            default:
                return "$"
        }
    }
    
    
    
    
}
