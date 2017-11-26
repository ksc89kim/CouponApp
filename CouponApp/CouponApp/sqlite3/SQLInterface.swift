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
        return nil
    }()
    var stmt:OpaquePointer? = nil
}
