//
//  DataBaseService.swift
//  PocketCash
//
//  Created by User on 11.12.17.
//  Copyright © 2017 Bimbetov Farabi. All rights reserved.
//

import UIKit
import GRDB

class DataBaseService: NSObject {
   
    static let sharedInstance = DataBaseService()
    var dbQueue: DatabaseQueue?
    
    override init() {
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let pathToDatabaseFile = "\(documentsPath)/database.sqlite"
            self.dbQueue = try DatabaseQueue(path: pathToDatabaseFile)
            try self.dbQueue?.inDatabase { db in
                try db.execute(
                    "CREATE TABLE IF NOT EXISTS pocketCash (" +
                        "id INTEGER PRIMARY KEY, " +
                        "cash INTEGER NOT NULL, " +
                        "date DATETIME NOT NULL, " +
                        "comment TEXT NOT NULL, " +
                        "income BOOLEAN NOT NULL, " +
                        "category TEXT NOT NULL)")
                try db.execute(
                    "CREATE TABLE IF NOT EXISTS user (" +
                        "name TEXT NOT NULL, " +
                        "surname TEXT NOT NULL, " +
                        "date TEXT NOT NULL, " +
                    "gender TEXT NOT NULL)")
            }
        } catch {
            NSLog("Failed to create database")
        }
    }
    
    func getCashOperation(fromRow row: Row) -> CashOperation {
        let id: Int = Int(arc4random())
        let cash: Int = row["cash"]
        let date: Date = row["date"]
        let comment: String = row["comment"]
        let income: Bool = row["income"]
        let category: String = row["category"]
        
        return CashOperation(id: id, cash: cash, date: date, comment: comment, income: income, category: category)
    }
    
    func checkExistingDB() -> Bool {
        var isUsed = false
        do {
            try self.dbQueue?.inDatabase { db in
                let exist = try Int.fetchOne(db, "SELECT COUNT(*) FROM cash")!
                isUsed = exist != 0
            }
        } catch {
            NSLog("Failed to insert new ticket to datebase.")
            NSLog("Error: unknown error")
        }
        return isUsed
    }
    
    func insertCashOperation(cashOperation: CashOperation) {
        do {
            try self.dbQueue?.inDatabase { db in
                try db.execute(
                        "INSERT INTO pocketCash (cash, date, comment, income, category) " +
                        "VALUES (?, ?, ?, ?, ?)",
                        arguments: [cashOperation.cash, cashOperation.date, cashOperation.comment, cashOperation.income, cashOperation.category])
                    NSLog("CashOperation with date \(cashOperation.date) was inserted")
            }
        } catch let error as DatabaseError {
            NSLog("Failed to insert new cashOperation to datebase.")
            NSLog("Error: \(String(describing: error.message))")
            NSLog("Request: \(String(describing: error.sql))")
        } catch {
            NSLog("Failed to insert new cashOperation to datebase.")
            NSLog("Error: unknown error")
        }
    }
    
    func deleteAllCashOperation() {
        do {
            try self.dbQueue?.inDatabase { db in
                let deleteAllCashOperation = try String.fetchAll(db, "DELETE FROM pocketCash")
                print("DeleteCashOperation = \(deleteAllCashOperation)")
            }
        } catch let error as DatabaseError {
            NSLog("Failed to delete all elements from datebase")
            NSLog("Error: \(String(describing: error.message))")
            NSLog("Request: \(String(describing: error.sql))")
        } catch {
            NSLog("Failed to delete all elements from datebase")
            NSLog("Error: unknown error")
        }
    }
    
    func readCashOperation() -> [CashOperation] {
        var cashOperations: [CashOperation] = []
        do {
            try self.dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM pocketCash")
                while let row = try rows.next() {
                    let cashOperation = self.getCashOperation(fromRow: row)
                    cashOperations.append(cashOperation)
                    print("last cashOperation: \(cashOperation)")
                }
                print("cashOperations: \(cashOperations)")
            }
        } catch {
            NSLog("Failed to read from database")
        }
        return cashOperations
    }
    
    func insertUser(user: User) {
        do {
            try self.dbQueue?.inDatabase { db in
                try db.execute(
                    "INSERT INTO user (name, surname, date, gender) " +
                    "VALUES (?, ?, ?, ?)",
                    arguments: [user.name, user.surname, user.date, user.gender])
                NSLog("User with name \(user.name) was inserted")
            }
        } catch let error as DatabaseError {
            NSLog("Failed to insert new cashOperation to datebase.")
            NSLog("Error: \(String(describing: error.message))")
            NSLog("Request: \(String(describing: error.sql))")
        } catch {
            NSLog("Failed to insert new cashOperation to datebase.")
            NSLog("Error: unknown error")
        }
    }
    
    func readUser() -> [User] {
        var userInfo: [User] = []
        do {
            try self.dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM user")
                while let row = try rows.next() {
                    let currentUser = self.getUser(fromRow: row)
                    userInfo.append(currentUser)
                    print("currentUser: \(currentUser)")
                }
                print("userInfo: \(userInfo)")
            }
        } catch {
            NSLog("Failed to read from database")
        }
        return userInfo
    }
    
    func getUser(fromRow row: Row) -> User {
        let name: String = row["name"]
        let surname: String = row["surname"]
        let date: String = row["date"]
        let gender: String = row["gender"]
        
        return User(name: name, surname: surname, date: date, gender: gender)
    }
}
