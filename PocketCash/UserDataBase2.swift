//
//  UserDataBase.swift
//  PocketCash
//
//  Created by User on 13.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit
import GRDB

class UserDataBase: NSObject {
    // static let sharedInstanceUserDB = UserDataBase()
    var dbQueue: DatabaseQueue?
//    let name: String
//    let surname: String
//    let date: String
//    let gender: String
    override init() {
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let pathToDatabaseFile = "\(documentsPath)/database.sqlite"
            self.dbQueue = try DatabaseQueue(path: pathToDatabaseFile)
            try self.dbQueue?.inDatabase { db in
                try db.execute(
                    "CREATE TABLE IF NOT EXISTS user (" +
                        "name TEXT NOT NULL " +
                        "surname TEXT NOT NULL, " +
                        "date TEXT NOT NULL, " +
                        "gender TEXT NOT NULL)")
            }
        } catch {
            NSLog("Failed to create database")
        }
    }
    
    func checkExistingDB() -> Bool {
        var isUsed = false
        do {
            try self.dbQueue?.inDatabase { db in
                let exist = try Int.fetchOne(db, "SELECT COUNT(*) FROM user")!
                isUsed = exist != 0
            }
        } catch {
            NSLog("Failed to insert new ticket to datebase.")
            NSLog("Error: unknown error")
        }
        return isUsed
    }

    
}
