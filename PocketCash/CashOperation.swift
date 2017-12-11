//
//  CashOperation.swift
//  PocketCash
//
//  Created by User on 11.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit

class CashOperation: NSObject {
    let id: Int
    let cash: Int
    let date: Date
    let comment: String
    let income: Bool
    let category: String
    
    convenience init(cash: Int, date: Date, comment: String, income: Bool, category: String) {
        self.init(id: 0, cash: cash, date: date, comment: comment, income: true, category: category)
    }
    
    init(id: Int, cash: Int, date: Date, comment: String, income: Bool, category:String) {
        self.id = id
        self.cash = cash
        self.date = date
        self.comment = comment
        self.income = income
        self.category = category
    }
    
}
