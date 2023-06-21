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
    let error = PublishSubject<Error>()
    let loadedMertchant = PublishSubject<any MerchantListable>()
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

    let loadedUserData = self.loadUserData(phoneNumber: loadedPhoneNumber, errorObserver: subject.error.asObserver())

    let addLoginViewController = Observable<any MerchantListable>.merge(
      subject.error
        .withLatestFrom(subject.loadedMertchant),
      loadedPhoneNumber
        .filter { $0 == nil }
        .withLatestFrom(subject.loadedMertchant)
    )

    let addMainViewController = loadedUserData
      .withLatestFrom(subject.loadedMertchant)

    self.outputs = IntroOutputs(
      addLoginViewController: addLoginViewController,
      addMainViewController: addMainViewController
    )
  }

  // MARK: - Method

  private func loadMerchant(subject: Subject) -> Observable<any MerchantListable> {
    return subject.loadMertchant
      .flatMapLatest { _ -> Observable<RepositoryResponse> in
        return CouponRepository.instance.rx.loadMerchantData()
          .asObservable()
          .suppressAndFeedError(into: subject.error)
    }
    .compactMap { (response: RepositoryResponse) -> (any MerchantListable)? in response.data as? (any MerchantListable) }
    .do(onNext: { (list: MerchantListable) in
      subject.loadedMertchant.onNext(list)
    })
    .share()
  }

  private func loadPhoneNumber(merchant: Observable<any MerchantListable>) -> Observable<String?> {
    return merchant
       .map { _ -> String? in
         let phone: PhoneType = DIContainer.resolve(for: PhoneKey.self)
         return phone.loadNumber()
     }
    .share()
  }

  private func loadUserData(phoneNumber: Observable<String?>, errorObserver: AnyObserver<Error>) -> Observable<RepositoryResponse> {
    return phoneNumber
      .filterNil()
      .flatMapLatest { phoneNumber -> Observable<RepositoryResponse> in
        return  CouponRepository.instance.rx.loadUserData(phoneNumber: phoneNumber)
          .asObservable()
          .suppressAndFeedError(into: errorObserver)
          .do(onNext: { (response: RepositoryResponse) in
            guard let user = response.data as? User else { return }
            Me.instance.update(user: user)
          })
      }
  }
}
