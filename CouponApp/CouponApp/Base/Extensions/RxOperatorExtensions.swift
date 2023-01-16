//
//  RxOperatorExtensions.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/12.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import RxSwift

extension ObservableType {

  func suppressError() -> Observable<Element> {
    return self.retry { _ in
      return Observable<Element>.empty()
    }
  }

  func suppressAndFeedError<S: ObserverType>(
    into listener: S
  ) -> Observable<Element> where S.Element == Swift.Error {
    return self.`do`(onError: { (error: Error) in
      listener.onNext(error)
    })
    .suppressError()
  }
}
