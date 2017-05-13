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
    @IBOutlet weak var domesticPicker: UIPickerView!
    @IBOutlet weak var foreignPicker: UIPickerView!
    
    @IBOutlet weak var convertTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: variables
    var currencies = Currency.list.shared.cur
    
    var domesticCurrency:String = ""
    var foreignCurrency:String = ""
    
    var domesticCurrencyARR:[String] = [""]
    var foreignCurrencyARR:[String] = [""]
    
    var currentSelection: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        convertTextField.keyboardType = UIKeyboardType.numberPad
        
        // Do any additional setup after loading the view.
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getData()
        
        
        
        self.domesticPicker.reloadAllComponents()
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        currentSelection = Data.pickerData[row]
        return Data.pickerData[row]
    }
    
    
    
    // MARK: USER Functions
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
                let rate = self.data._exchangeRateDict[domForString]!
                foreignValue = foreignValue * rate
                
                let foreignValueString = String.localizedStringWithFormat("%.2f %@",foreignValue,"")
                
                let hSymbol = getSymbol(domesticCurrency)
                let fSymbol = getSymbol(foreignCurrency)
                resultLabel.text! = hSymbol + "\(domesticValue)" + fSymbol + foreignValueString
            }
            else{
                convertTextField.text! = "Invalid Entry"
                resultLabel.text! = "No result"
            }
        }
    }

    func getData(){
        let myYQL = YQL()
        let queryString = "select * from yahoo.finance.xchange where pair in (\"CADCAD\", \"CADCNY\", \"CADEUR\", \"CADGBP\", \"CADJPY\", \"CADUSD\", \"CNYCAD\", \"CNYCNY\", \"CNYEUR\", \"CNYGBP\", \"CNYJPY\", \"CNYUSD\", \"EURCAD\", \"EURCNY\", \"EUREUR\", \"EURGBP\", \"EURJPY\", \"EURUSD\", \"GBPCAD\", \"GBPCNY\", \"GBPEUR\", \"GBPGBP\", \"GBPJPY\", \"GBPUSD\", \"JPYCAD\", \"JPYCNY\", \"JPYEUR\", \"JPYGBP\", \"JPYJPY\", \"JPYUSD\", \"USDCAD\", \"USDCNY\", \"USDEUR\", \"USDGBP\", \"USDJPY\", \"USDUSD\")"
    
        // Network session is asyncronous so use a closure to act upon data once data is returned
        myYQL.query(queryString) { jsonDict in
            // With the resulting jsonDict, pull values out
            // jsonDict["query"] results in an Any? object
            // to extract data, cast to a new dictionary (or other data type)
            // repeat this process to pull out more specific information
            let queryDict = jsonDict["query"] as! [String: Any]
            //let rateDict = queryDict["rate"] as! [String: Any]
            //print(queryDict["count"]!)
            //print(queryDict["results"]!)
            //print(rateDict["Rate"]!)
            let result = queryDict["results"]! as! [String: Any]
            let rate = result["rate"]! as! [[String: Any]]
            
            var index = 0
            
            for _ in 0..<36 {
                let name = rate[index]["id"] as! [String: Any]
                
                if let rat = rate[index]["Rate"]! as? String {
                    let ratFloat = Float(rat)
                    
                    self.data._rates.append(ratFloat!)
                    self.data._exchangeRateDict[name] = ratFloat!
                }
                index = index + 1
            }
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
