//
//  TransactionViewController.swift
//  PocketCash
//
//  Created by User on 20.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {
  
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cashSumm: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var toPass: Int = 0
    var dictionaryData = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let spentForProduct = dictionaryData[toPass]["summa"]! as NSString
        self.descriptionLabel.text =  dictionaryData[toPass]["comment"]!
        self.dateLabel.text = dictionaryData[toPass]["date"]!
        self.cashSumm.text = dictionaryData[toPass]["cash"]!
        self.categoryLabel.text = dictionaryData[toPass]["category"]!
        // Do any additional setup after loading the view.
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

}
