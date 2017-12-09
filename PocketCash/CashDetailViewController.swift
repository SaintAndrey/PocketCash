//
//  CashDetailViewController.swift
//  PocketCash
//
//  Created by User on 01.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit


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
    
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cashChangesButoon: UIButton!
    @IBOutlet var cashChangesView: UIView!
    
    var currentAccount: Int = 1
    var tableCellCount: Int = 1
    //var currentCash = "22 000p."
    var imagesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesArray = ["Flash drive",
                       "Multicharging ",
                       "Cover for CD",
                       "Car charging"]
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
       // tableView.register(YourCell.self, forCellReuseIdentifier: "Product Cell")
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getBalanceFromBD()
        tableView.reloadData()
    }
    
    @IBAction func cashChangesButoonPressed(){
        self.view.addSubview(self.cashChangesView)
        //self.cashChangesView.frame = UIScreen.main.bounds
        //view.isUserInteractionEnabled = false
        let screenSize:CGRect = UIScreen.main.bounds
        cashChangesView.frame.size.height = screenSize.height * 0.50
        cashChangesView.frame.size.width = screenSize.width
        cashChangesView.frame = CGRect(0, screenSize.height * 0.50 - 60, screenSize.width, screenSize.height * 0.50)
        print("cashChangesButoonPressed")
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesArray.count// your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Product Cell", for: indexPath) as! YourCell
        cell.cellImage?.image = UIImage(named: "balanc_plus_icon")!
        cell.cellCash?.text = "22 000p."
        cell.cellDate?.text = "04.12.2017"
        cell.cellTitle?.text = "Данные о местоположении недоступны"
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
