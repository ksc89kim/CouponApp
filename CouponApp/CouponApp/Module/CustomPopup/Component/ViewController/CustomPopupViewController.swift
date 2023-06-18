//
//  CustomPopupViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum CustomPopupViewControllerKey: InjectionKey {
  typealias Value = CustomPopupViewController
}


final class CustomPopupViewController: BaseViewController, Injectable {

  // MARK: - UI Component

  @IBOutlet weak var popupView: RoundedView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var popupCenterYConstraint: NSLayoutConstraint!
  @IBOutlet weak var okButton: UIButton!

  // MARK: - Property

  @Inject(CustomPopupViewModelKey.self)
  var customPopupViewModel: CustomPopupViewModelType

  // MARK: - Init

  init() {
    super.init(nibType: .customPopupViewController)
    self.modalPresentationStyle = .overCurrentContext
    self.modalTransitionStyle = .crossDissolve
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.customPopupViewModel.inputs.showPopup.onNext(())
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()

    self.okButton.rx.tap
      .bind(to: self.customPopupViewModel.inputs.onOk)
      .disposed(by: self.disposeBag)
  }

  override func bindOutputs() {
    super.bindOutputs()

    self.customPopupViewModel.outputs?.close
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.close)
      .disposed(by: self.disposeBag)

    self.customPopupViewModel.outputs?.showAnimation
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showAnimation)
      .disposed(by: self.disposeBag)

    self.customPopupViewModel.outputs?.title
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.titleLabel.rx.text)
      .disposed(by: self.disposeBag)

    self.customPopupViewModel.outputs?.content
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.contentLabel.rx.text)
      .disposed(by: self.disposeBag)

    self.customPopupViewModel.outputs?.popupViewAlpha
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.popupView.rx.alpha)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Animation Method

  fileprivate func showAnimation() {
    self.showFadeInAnimation()
  }

  private func showFadeInAnimation() {
    self.popupCenterYConstraint.constant = 0
    UIView.animate(withDuration: 0.35, animations: { [weak self] in
      self?.popupView.alpha = 1
      self?.view.layoutIfNeeded()
    })
  }

  // MARK: - Close

  fileprivate func close(configure: CustomPopupConfigurable) {
    self.dismiss(animated: true) {
      configure.completion?.onNext(())
    }
  }
}


private extension Reactive where Base: CustomPopupViewController {
  var close: Binder<CustomPopupConfigurable> {
    return Binder(self.base) { view, configure in
      view.close(configure: configure)
    }
  }

  var showAnimation: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.showAnimation()
    }
  }
}
