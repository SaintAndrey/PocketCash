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
    let cursor = DataBaseCursor()
    
    // MARK: Create Table
    override init() {
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            print("documentsPath - \(documentsPath)")
            let pathToDatabaseFile = "\(documentsPath)/database.sqlite"
            self.dbQueue = try DatabaseQueue(path: pathToDatabaseFile)
            try self.dbQueue?.inDatabase { db in
                try db.execute("""
                                CREATE TABLE IF NOT EXISTS transactionTable (
                                    id INTEGER PRIMARY KEY,
                                    cash DOUBLE NOT NULL,
                                    date DATETIME NOT NULL,
                                    comment TEXT,
                                    category TEXT NOT NULL,
                                    purseOrTarget TEXT NOT NULL,
                                    FOREIGN KEY (purseOrTarget) REFERENCES pursesAndTargets(namePurseOrTarget)
                                    FOREIGN KEY (category) REFERENCES category(nameCategory))
                                """)
                try db.execute("""
                                CREATE INDEX cashDay
                                ON transactionTable(date)
                                """)
                try db.execute("""
                                CREATE TABLE IF NOT EXISTS user (
                                    name TEXT NOT NULL,
                                    surname TEXT NOT NULL,
                                    date TEXT NOT NULL,
                                    gender TEXT NOT NULL)
                                """)
                try db.execute("""
                                CREATE TABLE IF NOT EXISTS pursesAndTargets (
                                    namePurseOrTarget TEXT PRIMARY KEY,
                                    amountCash DOUBLE NOT NULL,
                                    isPurse BOOLEAN NOT NULL)
                                """)
                try db.execute("""
                                CREATE TABLE IF NOT EXISTS logger (
                                    id INTEGER PRIMARY KEY,
                                    descriptionLog TEXT NOT NULL,
                                    date DATETIME NOT NULL)
                                """)
//                try db.execute("""
//                                CREATE TABLE IF NOT EXISTS budget (
//                                    name TEXT NOT NULL,
//                                    purseOrTarget TEXT NOT NULL,
//                                    maxAmount DOUBLE NOT NULL,
//                                    currentAmount DOUBLE NOT NULL,
//                                    beginDate DATETIME NOT NULL,
//                                    period DATETIME NOT NULL,
//                                    FOREIGN KEY (purseOrTarget) REFERENCES pursesAndTargets(namePurseOrTarget))
//                                """)
                try db.execute("""
                                CREATE TABLE IF NOT EXISTS category (
                                    nameCategory TEXT PRIMARY KEY)
                                """)
                try db.execute("""
                                CREATE TRIGGER insertTransactin BEFORE INSERT
                                ON transactionTable
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('INSERT into transaction', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER insertCategory BEFORE INSERT
                                ON category
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('INSERT into category', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER insertUser BEFORE INSERT
                                ON user
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('INSERT into user', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER insertPursesAndTargets BEFORE INSERT
                                ON pursesAndTargets
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('INSERT into pursesAndTargets', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER updateTransaction BEFORE UPDATE
                                ON transactionTable
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('UPDATE into transaction', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER updateCategory BEFORE UPDATE
                                ON category
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('UPDATE into category', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER updateUser BEFORE UPDATE
                                ON user
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('UPDATE into user', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER updatePursesAndTargets BEFORE UPDATE
                                ON pursesAndTargets
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('UPDATE into pursesAndTargets', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER deleteTransaction BEFORE DELETE
                                ON transactionTable
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('DELETE into transaction', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER deleteCategory BEFORE DELETE
                                ON category
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('DELETE into category', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER deleteUser BEFORE DELETE
                                ON user
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('DELETE into user', datetime('now'));
                                END
                                """)
                try db.execute("""
                                CREATE TRIGGER deletePursesAndTargets BEFORE DELETE
                                ON pursesAndTargets
                                BEGIN
                                INSERT INTO logger(descriptionLog, date) VALUES ('DELETE into pursesAndTargets', datetime('now'));
                                END
                                """)


            }
        } catch {
            NSLog("Failed to create database")
        }
    }
    
    func getCashOperation(fromRow row: Row) -> CashOperation {
        let id: Int = Int(arc4random())
        let cash: Int = row["cash"]
        let date: String = row["date"]
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
    
    // MARK: Insert Into Table
    func insertTransaction(transaction: Transaction) {
        do {
            try self.dbQueue?.inDatabase { db in
                try db.execute(
                        "INSERT INTO transactionTable (cash, date, comment, category, purseOrTarget) " +
                        "VALUES (?, ?, ?, ?, ?)",
                        arguments: [transaction.cash, transaction.date, transaction.comment, transaction.category, transaction.purseOrTarget])
                    NSLog("CashOperation with date \(transaction.date) was inserted")
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
    
    func insertPurseOrTarger(purseOrTarget: PurseOrTarget) {
        do {
            try self.dbQueue?.inDatabase { db in
                try db.execute(
                    "INSERT INTO pursesAndTargets (namePurseOrTarget, amountCash, isPurse) " +
                    "VALUES (?, ?, ?)",
                    arguments: [purseOrTarget.name, purseOrTarget.amountCash, purseOrTarget.isPurse])
                if (purseOrTarget.isPurse) {
                    NSLog("Purse \(purseOrTarget.name) was inserted")
                } else {
                    NSLog("Target \(purseOrTarget.name) was inserted")
                }
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
    
    
    func insertCategory(category: Category) {
        do {
            try self.dbQueue?.inDatabase { db in
                try db.execute(
                    "INSERT INTO category (nameCategory) " +
                    "VALUES (?)",
                    arguments: [category.nameCategory])
                    NSLog("Category \(category.nameCategory) was inserted")
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
    
    // MARK: Get Function
    func getUser() -> [User] {
        var userInfo: [User] = []
        do {
            try self.dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, "SELECT * FROM user")
                while let row = try rows.next() {
                    let currentUser = cursor.getUser(fromRow: row)
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
    
    func getCashDay() -> [CashDay] {
        var cashDay: [CashDay] = []
        let selectCashDay = """
                    SELECT sum(cash), date
                    FROM transactionTable
                    GROUP BY date
                    ORDER BY date DESC;
                    """
        do {
            try self.dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, selectCashDay)
                while let row = try rows.next() {
                    let currentCashDay = cursor.getCashDay(fromRow: row)
                    cashDay.append(currentCashDay)
                    print("currentCashDay: \(currentCashDay)")
                }
                print("cashDay: \(cashDay)")
            }
        } catch {
            NSLog("Failed to read from database")
        }
        return cashDay
    }
    
    func getTransactionOnDay(_ day: Date) -> [Transaction] {
        var transactions: [Transaction] = []
        do {
            try self.dbQueue?.inDatabase { db in
                let rows = try Row.fetchCursor(db, """
                    SELECT *
                    FROM transactionTable
                    WHERE date = \(day)
                    ORDER BY date DESC;
                    """)
                while let row = try rows.next() {
                    let currentTransaction = cursor.getTransaction(fromRow: row)
                    transactions.append(currentTransaction)
                    print("currentTransaction: \(currentTransaction)")
                }
                print("transactions: \(transactions)")
            }
        } catch {
            NSLog("Failed to read from database")
        }
        return transactions
    }
    
}
