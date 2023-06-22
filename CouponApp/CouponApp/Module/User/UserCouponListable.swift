//
//  UserCouponListable.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/06/22.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

enum UserCouponListKey: InjectionKey {
  typealias Value = UserCouponListable
}


protocol UserCouponListable: AnyObject, Listable, Injectable where ListType == UserCouponType {
}
