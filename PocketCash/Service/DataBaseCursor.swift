//
//  DataBaseCursor.swift
//  PocketCash
//
//  Created by Andrey on 21/12/2017.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit
import GRDB

class DataBaseCursor: NSObject {
    
    func getUser(fromRow row: Row) -> User {
        let name: String = row["name"]
        let surname: String = row["surname"]
        let date: String = row["date"]
        let gender: String = row["gender"]
        
        return User(name: name, surname: surname, date: date, gender: gender)
    }
    
    func getCashDay(fromRow row: Row) -> CashDay {
        let cash: Double = row["cash"]
        let date: Date = row["date"]
        
        return CashDay(cash: cash, date: date)
    }
}
