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
    let addLoginViewController = PublishSubject<Void>()
    let addMainViewController = PublishSubject<Void>()
  }

  struct Input {
    let addLoginViewController: Observable<Void>
    let addMainViewController: Observable<Void>
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

    let addLoginViewController = Observable.merge(
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

    let addMainViewController = loadedUserData
      .filter { $0 }
      .map { _ in }

    self.bind(
      input: .init(
        addLoginViewController: addLoginViewController,
        addMainViewController: addMainViewController

      )
    )
  }

  // MARK - Bind

  func bind(input: Input) {
    input.addLoginViewController
      .bind(to: self.state.addLoginViewController)
      .disposed(by: self.disposeBag)

    input.addMainViewController
      .bind(to: self.state.addMainViewController)
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
