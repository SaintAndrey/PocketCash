//
//  CashDetailViewController.swift
//  PocketCash
//
//  Created by User on 01.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit
import SwiftyJSON


class YourCell:UITableViewCell{
    
//    @IBOutlet weak var cellImage: UIImageView!
//    @IBOutlet weak var cellCash: UILabel!
//    @IBOutlet weak var cellTitle: UILabel!
//    @IBOutlet weak var cellDate: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellCash: UILabel!
    @IBOutlet weak var cellDate: UILabel!
}

class CashDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    //         CashDetailViewController
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cashChangesButoon: UIButton!
   
    //         CashChangesVIEW
    @IBOutlet var cashChangesView: UIView!
    @IBOutlet weak var cashChangesEXITButton: UIButton!
    @IBOutlet weak var incomeAndExpenses: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var addMoneyChangesButton: UIButton!
    
    var tableData = [Dictionary<String, String>]()
    
    var incomeCash: Bool = true
    var currentAccount: Int = 1
    var tableCellCount: Int = 1
    var imagesArray = [String]()
    
    let effectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        imagesArray = ["Flash drive",
                       "Multicharging ",
                       "Cover for CD",
                       "Car charging"]
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let allOperations = DataBaseService.sharedInstance.readCashOperation()
        let ticketsJsons = allOperations.map { $0.json() }
        let resultTicketsJsons = JSON( ticketsJsons)
        print(resultTicketsJsons.rawString() ?? "<null>")
   //     resultTicketsJsons
        //let rows = try Row.fetchCursor(db, "SELECT * FROM pocketCash")
//        while let resultTicketsJson = resultTicketsJsons.endIndex {
//            print("last cashOperation: \(resultTicketsJson["category"])")
//        }
//        for eachTicket in resultTicketsJsons {
//            if let category = eachTicket["category"] as? String {
//                print("current category: \(category)")
//            }
//
//
//        }
        for (key,resultTicketsJson):(String, JSON) in resultTicketsJsons {
            print("current category: \(resultTicketsJson["category"])")
            //        let id: Int
            //        let cash: Int
            //        let date: Date
            //        let comment: String
            //        let income: Bool
            //        let category: String
            self.tableData.append([ "id": "\(resultTicketsJson["id"])",
                                    "cash": "\(resultTicketsJson["cash"])",
                                    "date": "\(resultTicketsJson["date"])",
                                    "comment": "\(resultTicketsJson["comment"])",
                                    "income": "\(resultTicketsJson["income"])",
                                    "category": "\(resultTicketsJson["category"])"
                                   ])
        }
//        for resultTicketsJson in resultTicketsJsons {
//            guard let category = resultTicketsJsons["category"].string
//            else {
//                continue
//
//            }
//            print("current category: \(category)")
//        }
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addMoneyChangesButtonPressed() {
//        let id: Int
//        let cash: Int
//        let date: Date
//        let comment: String
//        let income: Bool
//        let category: String
        //let a:Int? = incomeAndExpenses.text.toInt()
        var cashOperation = CashOperation(
                            cash: Int(incomeAndExpenses.text!)!,
                            date: Date(),
                            comment: commentTextView.text!,
                            income: self.incomeCash,
                            category: categoryTextField.text!)
        
        // Записываем операцию в Базу данных
        DataBaseService.sharedInstance.insertCashOperation(cashOperation: cashOperation)
        let allOperations = DataBaseService.sharedInstance.readCashOperation()
       // print("allOperations: \(allOperations.) ")
        
        
        //let allOperations = DataBaseService.sharedInstance.readCashOperation()
        let ticketsJsons = allOperations.map { $0.json() }
        let resultTicketsJson = JSON(ticketsJsons)
        print(resultTicketsJson.rawString() ?? "<null>")
    }
    
    @IBAction func cashChangesExitButtonPressed() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.effectView.effect = nil
        self.effectView.removeFromSuperview()
        self.cashChangesView.removeFromSuperview()
    }
    
    @IBAction func cashChangesButoonPressed() {
        addBlurEffect()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        print("cashChangesButoonPressed")
    }
    
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: self.incomeCash = true
            break
        case 1: self.incomeCash = false
            break
        default:
            break
        }
        print("It is incomeCash? \(incomeCash)")
    }
    func addBlurEffect(){
        effectView.frame = view.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.effectView.effect = UIBlurEffect(style: .dark)
        view.addSubview(effectView)
      
        let screenSize:CGRect = UIScreen.main.bounds
        self.cashChangesView.frame = CGRect(0, 60, screenSize.width, screenSize.height * 0.50)
        view.addSubview(self.cashChangesView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count// your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Product Cell", for: indexPath) as! YourCell
        //cell.cellImage?.image = UIImage(named: "balanc_plus_icon")!
        print("income:  \(tableData[indexPath.row]["income"]!)")
        cell.cellImage?.image = UIImage(named: (tableData[indexPath.row]["income"]! == "true") ? "minus" : "plus")
        cell.cellCash?.text = tableData[indexPath.row]["cash"]!
        cell.cellDate?.text = tableData[indexPath.row]["date"]!
        cell.cellTitle?.text = tableData[indexPath.row]["comment"]!
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "operationViewController") as! operationViewController
//        vc.toPass = indexPath.row
//        vc.dictionaryData = tableData
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension CGRect {
    
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        
        self.init(x:x, y:y, width:w, height:h)
    }
}
