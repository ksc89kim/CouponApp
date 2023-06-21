//
//  AroundMerchantListViewModel.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/06.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import CoreLocation

enum AroundMerchantListViewModelKey: InjectionKey {
  typealias Value = MerchantListViewModelType
}

final class AroundMerchantListViewModel: MerchantListViewModel {

  // MARK: - Define

  struct Subject {
    let merchantList = BehaviorSubject<(any MerchantListable)?>(value: nil)
    let selectItem = PublishSubject<MerchantSelect>()
    let didUpdateLocation = PublishSubject<CLLocationManager>()
  }

  private enum Constant {
    static let maxDistance: Double = 1000
  }

  // MARK: - Init

  override init() {
    super.init()

    let subject = Subject()

    self.inputs = AroundMerchantListInputs(
      selecItem: subject.selectItem.asObserver(),
      merchantList: subject.merchantList.asObserver(),
      didUpdateLocation: subject.didUpdateLocation.asObserver()
    )

    self.outputs = AroundMerchantListOutputs(
      reloadSections: self.reloadSections(subject: subject),
      presentDetail: self.presentDetail(selectItem: subject.selectItem.asObservable())
    )
  }

  // MARK: - Method

  private func reloadSections(subject: Subject) -> Observable<[MerchantListSection]> {
    return subject.didUpdateLocation
      .withLatestFrom(subject.merchantList.filterNil()) { (
        manager: CLLocationManager,
        list: MerchantListable
      ) -> [MerchantListSection]? in
        guard let coor = manager.location?.coordinate else { return nil }
        let location = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
        let merchants = list.filter { (merchant: MerchantType) -> Bool in
          let diffDistance = location.distance(from: merchant.location)
          return diffDistance < Constant.maxDistance
        }
        guard merchants.isNotEmpty else { return nil }
        return [.init(items: merchants)]
      }
      .filterNil()
  }
}
