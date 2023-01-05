//
//  Me.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/05.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class Me {

  // MARK: - Property

  static var instance: Me = .init()
  fileprivate let userReleay: BehaviorRelay<User?> = .init(value: nil)

  // MARK: - Method

  func update(user: User) {
    self.userReleay.accept(user)
  }
}


extension Me: ReactiveCompatible {
}


extension Reactive where Base: Me {
  var user: Observable<User> {
    return self.base.userReleay
      .filterNil()
      .filter { (user: User) in user.isVaildID }
  }

  var userID: Observable<Int> {
    return self.user.map { (user: User) -> Int in user.id }
  }
}
