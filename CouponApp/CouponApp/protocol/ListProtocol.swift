//
//  ListProtocol.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

protocol ListProtocol {
    associatedtype ListType
    var list:[ListType] { get set }
    var count:Int { get }
    mutating func append(_ item:ListType)
    mutating func remove(_ at:Int)
    subscript(index:Int) -> ListType? { get set }
}

extension ListProtocol {
    var count:Int {
        return list.count
    }
    
    mutating func append(_ item:ListType) {
        list.append(item)
    }
    
    mutating func remove(_ at:Int) {
        list.remove(at: at)
    }
    
    subscript(index:Int) -> ListType? {
        get {
            return list[index]
        }
        set(newValue) {
            list[index] = newValue!
        }
    }
}
