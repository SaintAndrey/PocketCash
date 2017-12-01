//
//  ViewController.swift
//  PocketCash
//
//  Created by User on 30.11.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CashView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //var myView = UIView(frame: CGRectMake(100, 100, 100, 100))
        // 2.add myView to UIView hierarchy
        self.view.addSubview(CashView)
       
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.checkAction(sender:)))
        CashView.addGestureRecognizer(gesture)
        
    }

    @objc func checkAction(sender : UITapGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CashDetailViewController") as! CashDetailViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

