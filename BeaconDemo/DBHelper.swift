//
//  DBHelper.swift
//  DBDemo
//
//  Created by 이정진 on 2021/04/16.
//

//
//  DBHelper.swift
//  DBDemo
//
//  Created by 이정진 on 2021/04/16.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        
        db = openDatabase()
//        clear()
        createTable()
    }

    let dbPath: String = "beaconDB.sqlite"
    var db:OpaquePointer?
    
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.nurse")!.appendingPathComponent(dbPath)
        print(fileURL)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }

    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS BeaconDB(Timestamp TEXT, DeviceID TEXT, major INTEGER, minor INTEGER, prox TEXT, acc REAL, rssi INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("BeaconDB table created.")
            } else {
                print("BeaconDB table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(Timestamp: String, DeviceID: String, major: Int, minor: Int, prox: String, acc: Double, rssi: Int)
    {
//        let BeaconDBs = read()

        let insertStatementString = "INSERT INTO BeaconDB (Timestamp, DeviceID, major, minor, prox, acc, rssi) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (Timestamp as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (DeviceID as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(major))
            sqlite3_bind_int(insertStatement, 4, Int32(minor))
            sqlite3_bind_text(insertStatement, 5, (prox as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 6, acc)
            sqlite3_bind_int(insertStatement, 7, Int32(rssi))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func clear() {
        let clearString = "DROP TABLE BeaconDB;"
        var clearStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, clearString, -1, &clearStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(clearStatement) == SQLITE_DONE
            {
                print("BeaconDB table cleared.")
            } else {
                print("BeaconDB table could not cleared.")
            }
        } else {
            print("CLEAR statement could not be prepared.")
        }
        sqlite3_finalize(clearStatement)
        
    }
    
    func read() -> [BeaconDB] {
        let queryStatementString = "SELECT * FROM BeaconDB;"
        var queryStatement: OpaquePointer? = nil
        var psns : [BeaconDB] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let Timestamp = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let DeviceID = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let major = sqlite3_column_int(queryStatement, 2)
                let minor = sqlite3_column_int(queryStatement, 3)
                let prox = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let acc = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let rssi = sqlite3_column_int(queryStatement, 6)
                
                
                
                psns.append(BeaconDB(Timestamp: Timestamp, DeviceID: DeviceID, major: Int(major), minor: Int(minor), prox: prox, acc: Double(acc)!, rssi: Int(rssi)))
                print("Query Result:")
                print("\(Timestamp) | \(DeviceID) | \(major) | \(minor) | \(prox) | \(acc) | \(rssi)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
}
