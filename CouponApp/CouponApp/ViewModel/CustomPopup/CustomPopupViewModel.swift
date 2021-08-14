//
//  CustomPopupViewModel.swift
//  CouponApp
//
//  Created by sc.kim on 2020/12/06.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class CustomPopupViewModel: CustomPopupViewModelType {

  // MARK: - Define

  private struct Subject {
    let configure = BehaviorSubject<CustomPopup?>(value: nil)
    let onOk = PublishSubject<Void>()
    let viewDidLoad = PublishSubject<Void>()
  }

  // MARK: - Property

  var inputs: CustomPopupInputType { return self.customPopupInputs }
  var outputs: CustomPopupOutputType? { return self.customPopupOutputs }
  private let customPopupInputs: CustomPopupInputs
  private var customPopupOutputs: CustomPopupOutputs?

  // MARK: - Init

  init() {
    let subject = Subject()

    self.customPopupInputs = .init(
      configure: subject.configure.asObserver(),
      onOk: subject.onOk.asObserver(),
      viewDidLoad: subject.viewDidLoad.asObserver()
    )

    let close = self.close(subject: subject)
    let showAnimation = self.delayShowAnimation(subject: subject)
    let configure = self.configre(subject: subject)

    let title = self.title(configure: configure)
    let content = self.content(configure: configure)
    let popupViewAlpha = self.popupViewAlpha(configure: configure)
    let callback = self.callback(
      configure: configure,
      close: close
    )

    self.customPopupOutputs = .init(
      content: content,
      callback: callback,
      showAnimation: showAnimation,
      close: close,
      title: title,
      popupViewAlpha: popupViewAlpha
    )
  }

  // MARK: - Function

  private func close(subject: Subject) -> Observable<Void> {
    return subject.onOk.share()
  }

  private func delayShowAnimation(subject: Subject) -> Observable<Void> {
    return subject.viewDidLoad
      .delay(.milliseconds(100), scheduler: MainScheduler.instance)
  }

  private func configre(subject: Subject) -> Observable<CustomPopup> {
    return subject.viewDidLoad
      .withLatestFrom(subject.configure)
      .filterNil()
      .share()
  }

  private func title(configure: Observable<CustomPopup>) -> Observable<String> {
    return configure.map { $0.title }
  }

  private func content(configure: Observable<CustomPopup>) -> Observable<String> {
    return configure.map { $0.message }
  }

  private func popupViewAlpha(configure: Observable<CustomPopup>) -> Observable<CGFloat> {
    return configure.map { _ in 0 }
  }

  private func callback(configure: Observable<CustomPopup>, close: Observable<Void>) -> Observable<CustomPopup> {
    return close
      .withLatestFrom(configure)
  }
}
