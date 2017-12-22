//
//  CashDay.swift
//  PocketCash
//
//  Created by Andrey on 21/12/2017.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit

class CashDay: NSObject {
    let cash: Double
    let date: Date
    
    init(cash: Double, date: Date) {
        self.cash = cash
        self.date = date
    }
}
