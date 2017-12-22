//
//  Logger.swift
//  PocketCash
//
//  Created by Andrey on 20/12/2017.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit

class Logger: NSObject {
    
    let id: Int
    let descriptionLog: String
    let date: Date
    
    init(id: Int, descriptionLog: String, date: Date) {
        self.id = id
        self.descriptionLog = descriptionLog
        self.date = date
    }

}
