//
//  MerchantViewModel.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/03.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

class MerchantListViewModel: MerchantListViewModelType, Injectable {

  // MARK: - Define

  struct Subject {
    let merchantList = BehaviorSubject<(any MerchantListable)?>(value: nil)
    let selectItem = PublishSubject<MerchantSelect>()
  }

  // MARK: - Property

  var inputs: MerchantListInputType
  var outputs: MerchantListOutputType?

  // MARK: - Init

  init() {
    let subject = Subject()

    self.inputs = MerchantListInputs(
      selecItem: subject.selectItem.asObserver(),
      merchantList: subject.merchantList.asObserver()
    )

    self.outputs = MerchantListOutputs(
      reloadSections: self.reloadSections(merchantList: subject.merchantList.asObservable()),
      presentDetail: self.presentDetail(selectItem: subject.selectItem.asObservable())
    )
  }

  // MARK: - Methods

  func reloadSections(merchantList: Observable<(any MerchantListable)?>) -> Observable<[MerchantListSection]> {
    return merchantList.compactMap { (merchatList: MerchantListable?) -> [MerchantListSection]? in
      guard let merchatList = merchatList else { return nil }
      return [.init(items: merchatList.list)]
    }
  }

  func presentDetail(selectItem: Observable<MerchantSelect>) -> Observable<MerchantDetailConfigurable> {
    return selectItem.map { (select: MerchantSelect) -> MerchantDetailConfigurable in
      let positionY = select.cellFrame.origin.y - select.contentOffset.y + MerchantTableViewCell.Metric.headerTopHeight
      var frame = select.cellTopViewFrame
      frame.origin.y = positionY
      var configure: MerchantDetailConfigurable = DIContainer.resolve(for: MerchantDetailConfigurationKey.self)
      configure.cellCornerRadius = select.cornerRadius
      configure.cellTopViewFrame = frame
      configure.merchant = select.item
      return configure
    }
  }
}
