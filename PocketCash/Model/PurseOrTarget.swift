//
//  PurseOrTarget.swift
//  PocketCash
//
//  Created by Andrey on 20/12/2017.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit

class PurseOrTarget: NSObject {

    let name: String
    let amountCash: Double
    let isPurse: Bool
    
    init(name: String, amountCash: Double, isPurse: Bool) {
        self.name = name
        self.amountCash = amountCash
        self.isPurse = isPurse
    }
}
