//
//  IntroViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/10/25.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa

final class IntroViewModel: ViewModel {

  // MARK - Action

  struct Action {
    let loadMerchantData = PublishSubject<Void>()
  }

  // MARK - State

  struct State {
    let showLoginviewcontroller = PublishSubject<Void>()
    let showMainViewController = PublishSubject<Void>()
  }

  // MARK - Property

  var action = Action()
  var state = State()
  var disposeBag = DisposeBag()

  // MARK - Init

  init() {

    let loadedMerchantData = self.action.loadMerchantData
      .flatMapLatest { _ -> Observable<Bool> in
        return RxCouponData.loadMerchantData().asObservable()
    }
    .share()

    let userPhoneNumber = loadedMerchantData
      .filter { $0 }
      .map { [weak self] _ -> String? in
        return self?.getPhoneNumber()
    }.share()

    let loadedUserData = userPhoneNumber
      .filter { $0 != nil }
      .flatMapLatest { phoneNumber -> Observable<Bool> in
        guard let phoneNumber = phoneNumber else {
          return .empty()
        }
        return  RxCouponData.loadUserData(phoneNumber: phoneNumber).asObservable()
    }

    let showLoginviewcontroller = Observable.merge(
      loadedMerchantData
        .filter { !$0 }
        .map { _ in },
      userPhoneNumber
        .filter { $0 == nil }
        .map { _ in },
      loadedUserData
        .filter { !$0 }
        .map { _ in }
    )

    let showMainViewController = loadedUserData
      .filter { $0 }
      .map { _ in }

    showLoginviewcontroller
      .bind(to: self.state.showLoginviewcontroller)
      .disposed(by: self.disposeBag)

    showMainViewController
      .bind(to: self.state.showMainViewController)
      .disposed(by: self.disposeBag)

  }

  private func getPhoneNumber() -> String? {
    return UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
  }
}
