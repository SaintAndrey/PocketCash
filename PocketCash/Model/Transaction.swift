//
//  Transaction.swift
//  PocketCash
//
//  Created by Andrey on 20/12/2017.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit

class Transaction: NSObject {
    let id: Int
    let cash: Double
    let date: Date
    let comment: String
    let category: String
    let purseOrTarget: String
    
    init(id: Int, cash: Double, date: Date, comment: String?, category: String, purseOrTarget: String) {
        self.id = id
        self.cash = cash
        self.date = date
        if (comment?.isEmpty == true) {
            self.comment = String()
        } else {
            self.comment = comment!
        }
        self.category = category
        self.purseOrTarget = purseOrTarget
    }

}
