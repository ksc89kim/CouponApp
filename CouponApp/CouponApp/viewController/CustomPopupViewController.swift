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

final class CustomPopupViewController: BaseViewController {

  // MARK: - UI Component

  @IBOutlet weak var popupView: RoundedView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var popupCenterYConstraint: NSLayoutConstraint!
  @IBOutlet weak var okButton: UIButton!

  // MARK: - Properties

  fileprivate let viewModel = CustomPopupViewModel()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewModel.inputs.viewDidLoad.onNext(())
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()

    self.okButton.rx.tap
      .bind(to: self.viewModel.inputs.onOk)
      .disposed(by: self.disposeBag)
  }

  override func bindOutputs() {
    super.bindOutputs()

    self.viewModel.outputs.close
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.close)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.showAnimation
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showAnimation)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.title
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.titleLabel.rx.text)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.content
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.contentLabel.rx.text)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.popupViewAlpha
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.popupView.rx.alpha)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs.callback
      .subscribe(onNext: { configrue in
        configrue.callback?.onNext(())
      })
      .disposed(by: self.disposeBag)
  }

  // MARK: - Animation Function

  fileprivate func showAnimation() {
    self.showFadeInAnimation()
  }

  private func showGiveAnimation() {
    self.popupView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    UIView.animate(
      withDuration: 1.0,
      delay: 0,
      usingSpringWithDamping: 0.3,
      initialSpringVelocity: 0,
      options: .curveEaseInOut,
      animations: { [weak self] in
        self?.popupView.transform = .identity
      }, completion: nil
    )
  }

  private func showFadeInAnimation() {
    self.popupCenterYConstraint.constant = 0
    UIView.animate(withDuration: 0.35, animations: { [weak self] in
      self?.popupView.alpha = 1
      self?.view.layoutIfNeeded()
    })
  }

  // MARK: - Close

  fileprivate func close() {
    self.willMove(toParentViewController: nil)
    self.view.removeFromSuperview()
    self.removeFromParentViewController()
  }
}

extension Reactive where Base: CustomPopupViewController {

  var close: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.close()
    }
  }

  var showAnimation: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.showAnimation()
    }
  }

  var configure: AnyObserver<CustomPopup?> {
    return self.base.viewModel.inputs.configure
      .asObserver()
  }

}
