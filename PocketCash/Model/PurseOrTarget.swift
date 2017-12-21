//
//  PurseOrTarget.swift
//  PocketCash
//
//  Created by Andrey on 20/12/2017.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit

class PurseOrTarget: NSObject {

    let id: Int
    let name: String
    let amountCash: Double
    let isPurse: Bool
    
    init(id: Int, name: String, amountCash: Double, isPurse: Bool) {
        self.id = id
        self.name = name
        self.amountCash = amountCash
        self.isPurse = isPurse
    }
}
