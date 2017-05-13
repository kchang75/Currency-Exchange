//
//  FavoriteTableViewController.swift
//  CurrencyExchange
//
//  Created by CampusUser on 5/6/17.
//  Copyright © 2017 Kristi Chang. All rights reserved.
//

import UIKit

protocol displayCurrencies: class {
    func setCurrencies(c: [Currency])
}

class FavoriteTableViewController: UITableViewController {
    
    // MARK: variables
    weak var delegate: displayCurrencies? = nil
    var currencies = Currency.list.shared.currencies

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table View Data

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var currency : Currency
        currency = currencies[indexPath.row]
        cell.textLabel?.text = currency.name
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currencies[indexPath.row].check = !currencies[indexPath.row].check
        if currencies[indexPath.row].check {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.setCurrencies(c: currencies)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Swipe function
    func handleSwipe(_ sender: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
        
    }

}
