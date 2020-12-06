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

final class CustomPopupViewModel: ViewModel {

  struct Inputs {
    let configure = BehaviorSubject<CustomPopup?>(value: nil)
    let onOk = PublishSubject<Void>()
    let viewDidLoad = PublishSubject<Void>()
  }

  struct Outputs {
    let callback = PublishSubject<CustomPopup>()
    let showAnimation = PublishSubject<Void>()
    let close = PublishSubject<Void>()
    let title = PublishSubject<String>()
    let content = PublishSubject<String>()
    let popupViewAlpha = PublishSubject<CGFloat>()
  }

  struct BindInputs {
    let callback: Observable<CustomPopup>
    let showAnimation: Observable<Void>
    let close: Observable<Void>
    let title: Observable<String>
    let content: Observable<String>
    let popupViewAlpha: Observable<CGFloat>
  }

  // MARK: - Property

  let inputs = Inputs()
  let outputs = Outputs()
  private let disposeBag = DisposeBag()

  // MARK: - Init

  init() {
    let close = self.close()
    let showAnimation = self.delayShowAnimation()

    let configure = self.configre()

    let title = self.title(configure: configure)
    let content = self.content(configure: configure)
    let popupViewAlpha = self.popupViewAlpha(configure: configure)
    let callback = self.callback(
      configure: configure,
      close: close
    )

    self.bind(
      inputs: .init(
        callback: callback,
        showAnimation: showAnimation,
        close: close,
        title: title,
        content: content,
        popupViewAlpha: popupViewAlpha
      )
    )
  }

  // MARK: - Bind

  func bind(inputs: BindInputs) {
    inputs.close
      .bind(to: self.outputs.close)
      .disposed(by: self.disposeBag)

    inputs.showAnimation
      .bind(to: self.outputs.showAnimation)
      .disposed(by: self.disposeBag)

    inputs.title
      .bind(to: self.outputs.title)
      .disposed(by: self.disposeBag)

    inputs.content
      .bind(to: self.outputs.content)
      .disposed(by: self.disposeBag)

    inputs.popupViewAlpha
      .bind(to: self.outputs.popupViewAlpha)
      .disposed(by: self.disposeBag)

    inputs.callback
      .bind(to: self.outputs.callback)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Function

  private func close() -> Observable<Void> {
    return self.inputs.onOk.share()
  }

  private func delayShowAnimation() -> Observable<Void> {
    return self.inputs.viewDidLoad
      .delay(.milliseconds(100), scheduler: MainScheduler.instance)
  }

  private func configre() -> Observable<CustomPopup> {
    return self.inputs.viewDidLoad
      .withLatestFrom(self.inputs.configure)
      .filterNil()
      .share()
  }

  private func title(
    configure: Observable<CustomPopup>
  ) -> Observable<String> {
    return configure.map { $0.title }
  }

  private func content(
    configure: Observable<CustomPopup>
  ) -> Observable<String> {
    return configure.map { $0.message }
  }

  private func popupViewAlpha(
    configure: Observable<CustomPopup>
  ) -> Observable<CGFloat> {
    return configure.map { _ in 0 }
  }

  private func callback(
    configure: Observable<CustomPopup>,
    close: Observable<Void>
  ) -> Observable<CustomPopup> {
    return close
      .withLatestFrom(configure)
  }

}
