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

  struct Inputs {
    let loadMerchantData = PublishSubject<Void>()
  }

  struct Outputs {
    let addLoginViewController = PublishSubject<Void>()
    let addMainViewController = PublishSubject<Void>()
  }

  struct BindInputs {
    let addLoginViewController: Observable<Void>
    let addMainViewController: Observable<Void>
  }

  // MARK: - Property

  let inputs = Inputs()
  let outputs = Outputs()
  private let disposeBag = DisposeBag()

  // MARK: - Init

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
      inputs: .init(
        addLoginViewController: addLoginViewController,
        addMainViewController: addMainViewController

      )
    )
  }

  // MARK: - Bind

  func bind(inputs: BindInputs) {
    inputs.addLoginViewController
      .bind(to: self.outputs.addLoginViewController)
      .disposed(by: self.disposeBag)

    inputs.addMainViewController
      .bind(to: self.outputs.addMainViewController)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Functions

  private func loadMerchant() -> Observable<Bool> {
    return self.inputs.loadMerchantData
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
