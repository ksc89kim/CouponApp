//
//  Me.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/05.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift

final class Me {

  // MARK: - Define

  enum Constant {
    static let updateMeNotification: Notification.Name = .init("UpdateMeNotification")
  }

  // MARK: - Property

  static var instance: Me = .init()
  private var user: User?

  // MARK: - Method

  func update(user: User) {
    self.user = user
    NotificationCenter.default.post(.init(name: Constant.updateMeNotification, object: user))
  }
}


extension Me: ReactiveCompatible {
}


extension Reactive where Base: Me {
  var user: Observable<User> {
    return NotificationCenter.default.rx
      .notification(Me.Constant.updateMeNotification)
      .compactMap { (notification: Notification) -> User? in
        return notification.object as? User
      }
      .filter { (user: User) in user.isVaildID }
  }

  var userID: Observable<Int> {
    return self.user.map { (user: User) -> Int in user.id }
  }
}
