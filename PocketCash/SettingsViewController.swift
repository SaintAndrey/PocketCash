//
//  SettingsViewController.swift
//  PocketCash
//
//  Created by User on 13.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var dateOfBirthTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    
  //  var userData = [Dictionary<String, String>]()
    var userData: [String: String] = (["name":    "",
                                       "surname": "",
                                       "date":    "",
                                       "gender":  ""])
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Настройки"
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = button
        setupUserInfo()
        showUserInfo()
    }
    
    func showUserInfo() {
        if (userData["name"] != nil),(userData["surname"] != nil),(userData["date"] != nil),(userData["gender"] != nil){
            nameTF.text = userData["name"]!
            surnameTF.text = userData["surname"]!
            dateOfBirthTF.text = userData["date"]!
            genderTF.text = userData["gender"]!
        }
    }
    
    func setupUserInfo() {
        let userInfo = DataBaseService.sharedInstance.readUser()
        let allUsersInJsons = userInfo.map { $0.json() }
        let resultUserJsons = JSON(allUsersInJsons)
        print(resultUserJsons.rawString() ?? "<null>")
        self.userData.removeAll()
        for (_,resultUserJson):(String, JSON) in resultUserJsons {
            self.userData = (["name":    "\(resultUserJson["name"])",
                              "surname": "\(resultUserJson["surname"])",
                              "date":    "\(resultUserJson["date"])",
                              "gender":  "\(resultUserJson["gender"])"])
        }
    }
    
    @IBAction func deleteCashDB(_ sender: UIButton) {
        DataBaseService.sharedInstance.deleteAllCashOperation()
        let alert = UIAlertController(title: "Удалено", message: "Данные кошелька удалены", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func doneTapped(){
        guard let text1 = nameTF.text, !text1.isEmpty,
            let text2 = surnameTF.text, !text2.isEmpty,
            let text3 = dateOfBirthTF.text, !text3.isEmpty,
            let text4 = genderTF.text, !text4.isEmpty
            else {
                showToast(message: "Заполните все поля")
            return
        }
        let user1 = User(
            name:       nameTF.text!,
            surname:    surnameTF.text! ,
            date:       dateOfBirthTF.text!,
            gender:     genderTF.text!)
        
        // Записываем операцию в Базу данных
        DataBaseService.sharedInstance.insertUser(user: user1)
        
    }
}
extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
