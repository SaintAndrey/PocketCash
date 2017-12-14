//
//  User.swift
//  PocketCash
//
//  Created by User on 13.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    let name: String
    let surname: String
    let date: String
    let gender: String
   // let image: UInt8
    
//    convenience init(name: String, surname: String, date: String, gender: String) {
//        self.init(name: name, surname: surname, date: date, gender: gender)
//    }
    
    init(name: String, surname: String, date: String, gender: String) {
        self.name = name
        self.surname = surname
        self.date = date
        self.gender = gender
    }
    
    func json() -> JSON {
        let dict = ["name" : self.name,
                    "surname" : self.surname,
                    "date" : self.date,
                    "gender" : self.gender] as [String: Any?]
        return JSON(dict)
    }
}
