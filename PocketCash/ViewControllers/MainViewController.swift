//
//  MainViewController.swift
//  PocketCash
//
//  Created by User on 03.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyCell:UITableViewCell{
    @IBOutlet weak var pocketOrTargeImage: UIImageView!
    @IBOutlet weak var pocketOrTargeLabel: UILabel!
    @IBOutlet weak var summLabel: UILabel!
}

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "targeOrCash", for: indexPath) as! MyCell
        //cell.cellImage?.image = UIImage(named: "balanc_plus_icon")!
        print("income:  \(tableData[indexPath.row]["income"]!)")
        cell.pocketOrTargeImage?.image = UIImage(named: "accessory")!
        cell.pocketOrTargeLabel?.text = "Кошелек новый"
      //  cell.cellCash?.text = tableData[indexPath.row]["cash"]!
        cell.summLabel?.text = tableData[indexPath.row]["date"]!
       // cell.cellTitle?.text = tableData[indexPath.row]["comment"]!
        return cell
    }
    

//    @IBOutlet weak var currentCash: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var currentBalanc: Int = 0
    var tableData = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(editTapped))
        //navigationItem.rightBarButtonItem = button
        setupTableViewValues()
        setupUserName()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableViewValues()
        setupUserName()
    }

    func setupUserName() {
        let allOperations = DataBaseService.sharedInstance.readUser()
        let allOperationsInJsons = allOperations.map { $0.json() }
        let resultAllOperationsJsons = JSON(allOperationsInJsons)
        print(resultAllOperationsJsons.rawString() ?? "<null>")
        for (_,resultTicketsJson):(String, JSON) in resultAllOperationsJsons {
            userName.text = resultTicketsJson["name"].string 
        }
    }
    
    func setupTableViewValues() {
        let allOperations = DataBaseService.sharedInstance.readCashOperation()
        let allOperationsInJsons = allOperations.map { $0.json() }
        let resultAllOperationsJsons = JSON( allOperationsInJsons)
        print(resultAllOperationsJsons.rawString() ?? "<null>")
        self.tableData.removeAll()
        self.currentBalanc = 0
        for (_,resultTicketsJson):(String, JSON) in resultAllOperationsJsons {
            self.tableData.append([ "id": "\(resultTicketsJson["id"])",
                "cash": "\(resultTicketsJson["cash"])",
                "date": "\(resultTicketsJson["date"])",
                "comment": "\(resultTicketsJson["comment"])",
                "income": "\(resultTicketsJson["income"])",
                "category": "\(resultTicketsJson["category"])"])
            if (resultTicketsJson["income"] == true){
                if(self.tableData.last!["cash"] != nil) {
                     self.currentBalanc += Int(self.tableData.last!["cash"]!)!
                }
            } else {
                if(self.tableData.last!["cash"] != nil) {
                    self.currentBalanc -= Int(self.tableData.last!["cash"]!)!
                }
            }
        }
        //currentCash.text = String(self.currentBalanc)
    }
}
