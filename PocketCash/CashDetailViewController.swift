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
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        case 0: incomeCash = true
            break
        case 1: incomeCash = false
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
        return imagesArray.count// your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Product Cell", for: indexPath) as! YourCell
        cell.cellImage?.image = UIImage(named: "balanc_plus_icon")!
        cell.cellCash?.text = "22 000p."
        cell.cellDate?.text = "04.12.2017"
        cell.cellTitle?.text = "Купил маме цветы"
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
