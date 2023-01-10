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
import UIKit

final class IntroViewModel: IntroViewModelType {

  // MARK: - Define

  private struct Subject {
    let loadMertchant = PublishSubject<Void>()
  }

  // MARK: - Property

  var inputs: IntroInputType
  var outputs: IntroOutputType?

  // MARK: - Init

  init() {
    let subject = Subject()
    self.inputs = IntroInputs(
      loadMerchantData: subject.loadMertchant.asObserver()
    )

    let loadedMerchant = self.loadMerchant(subject: subject)

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

    self.outputs = IntroOutputs(
      addLoginViewController: addLoginViewController,
      addMainViewController: addMainViewController
    )
  }

  // MARK: - Method

  private func loadMerchant(subject: Subject) -> Observable<Bool> {
    return subject.loadMertchant
      .flatMapLatest { _ -> Observable<Bool> in
        return CouponRepository.instance.rx.loadMerchantData()
          .asObservable()
          .do(onNext: { (response: RepositoryResponse) in
            MerchantController.instance.merchantList = response.data as? MerchantList
          })
          .map { (response: RepositoryResponse) -> Bool in response.isSuccessed }
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
        return  CouponRepository.instance.rx.loadUserData(phoneNumber: phoneNumber)
          .asObservable()
          .do(onNext: { (response: RepositoryResponse) in
            guard let user = response.data as? User else { return }
            Me.instance.update(user: user)
          })
          .map { (response: RepositoryResponse) -> Bool in response.isSuccessed }
    }
  }
}
