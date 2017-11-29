//
//  SQLInterface.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 11. 26..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

enum SQLError: Error {
    case connectionError
    case queryError
    case otherError
}

class SQLInterface {
    lazy var db:OpaquePointer? = {
        var _db:OpaquePointer? = nil
        let path = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .last!.appendingPathComponent("coupon.db").path
        if sqlite3_open(path, &_db) == SQLITE_OK {
            return _db
        }
        print("Fail to connect database..")
        abort()
    }()
    var stmt:OpaquePointer? = nil
    
    init() {
    }
    
    deinit {
        if let db = db {
            sqlite3_close(db)
        }
    }
    
    /*
    func insert_value(value: Int32) throws {
        defer { sqlite3_finalize(stmt) }
        let query = "INSERT INTO test (id) VALUES (?)"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, value)
            if sqlite3_step(stmt) == SQLITE_DONE { return }
        }
        throw SQLError.QueryError
     }
 
 
    func get_values() throws -> [Int32] {
        guard db != nil else { throw SQLError.ConnectionError }
        defer { sqlite3_finalize(stmt) }
        var result = [Int32]()
        let query = "SELECT * FROM test"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let i:Int32 = sqlite3_column_int(stmt, 0)
                result.append(i)
            }
            return result
        }
        throw SQLError.QueryError
    }
     */
}
