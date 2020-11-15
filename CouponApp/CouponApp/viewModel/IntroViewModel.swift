//
//  IntroViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/10/25.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class IntroViewModel: ViewModel {

  struct Action {
    let loadMerchantData = PublishSubject<Void>()
  }

  struct State {
    let showLoginviewcontroller = PublishSubject<Void>()
    let showMainViewController = PublishSubject<Void>()
  }

  struct Input {
    let showLoginviewcontroller: Observable<Void>
    let showMainViewController: Observable<Void>
  }

  // MARK - Property

  var action = Action()
  var state = State()
  var disposeBag = DisposeBag()

  // MARK - Init

  init() {

    let loadedMerchant = self.loadMerchant()

    let loadedPhoneNumber = self.loadPhoneNumber(merchant: loadedMerchant)

    let loadedUserData = self.loadUserData(phoneNumber: loadedPhoneNumber)

    let showLoginviewcontroller = Observable.merge(
      loadedMerchant
        .filter { !$0 }
        .map { _ in },
      loadedPhoneNumber
        .filter { $0 == nil }
        .map { _ in },
      loadedUserData
        .filter { !$0 }
        .map { _ in }
    )

    let showMainViewController = loadedUserData
      .filter { $0 }
      .map { _ in }

    self.bind(
      input: .init(
        showLoginviewcontroller: showLoginviewcontroller,
        showMainViewController: showMainViewController

      )
    )
  }

  // MARK - Bind

  func bind(input: Input) {
    input.showLoginviewcontroller
      .bind(to: self.state.showLoginviewcontroller)
      .disposed(by: self.disposeBag)

    input.showMainViewController
      .bind(to: self.state.showMainViewController)
      .disposed(by: self.disposeBag)
  }

  // MARK - Functions

  private func loadMerchant() -> Observable<Bool> {
    return self.action.loadMerchantData
      .flatMapLatest { _ -> Observable<Bool> in
        return RxCouponData.loadMerchantData().asObservable()
    }
    .share()
  }

  private func loadPhoneNumber(merchant: Observable<Bool>) -> Observable<String?> {
    return merchant
       .filter { $0 }
       .map { [weak self] _ -> String? in
         return self?.getPhoneNumber()
     }
    .share()
  }

  private func getPhoneNumber() -> String? {
    return UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
  }

  private func loadUserData(phoneNumber: Observable<String?>) -> Observable<Bool> {
    return phoneNumber
      .filterNil()
      .flatMapLatest { phoneNumber -> Observable<Bool> in
        return  RxCouponData.loadUserData(phoneNumber: phoneNumber).asObservable()
    }
  }
}
