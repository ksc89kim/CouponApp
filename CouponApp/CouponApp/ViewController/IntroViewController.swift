//
//  IntroViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 11/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 인트로 관련 뷰 컨트롤러
final class IntroViewController: BaseViewController {

  // MARK: - UI Component

  @IBOutlet weak var stampView: IntroStampView!
  @IBOutlet weak var backgroundView: UIView!

  // MARK: - Property

  let viewModel = IntroViewModel()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel.inputs.loadMerchantData.onNext(())

    self.stampView.completion = { [weak self] in
      self?.fadeAnimation()
    };
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()
  }

  override func bindOutputs() {
    super.bindOutputs()

    self.viewModel.outputs?
      .addLoginViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.addLoginViewController)
      .disposed(by: self.disposeBag)

    self.viewModel.outputs?
      .addMainViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.addMainViewController)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Animation Method

  private func fadeAnimation() {
    self.backgroundView.alpha = 1
    UIView.animate(
      withDuration: 0.3,
      animations: { [weak self] in
        self?.backgroundView.alpha = 0
      },
      completion: { [weak self] finished in
        if finished {
          self?.backgroundView.isHidden = true
        }
      }
    )
  }

  // MARK: - Show ViewController

  fileprivate func addLoginViewController() {
    guard let bringSubView = self.backgroundView else {
      print("showLoginViewController - backgorundView nil")
      return
    }

    let loginViewController =  self.createViewController(
      storyboardName: CouponStoryBoardName.start.rawValue,
      withIdentifier: CouponIdentifier.loginNavigationController.rawValue
    )

    self.addViewController(viewController: loginViewController, bringSubView: bringSubView)
  }

  fileprivate func addMainViewController() {
    guard let bringSubView = self.backgroundView else {
      print("showMainViewController - backgorundView nil")
      return
    }

    let mainViewcontroller =  self.createViewController(storyboardName: CouponStoryBoardName.main.rawValue)
    self.addViewController(viewController: mainViewcontroller, bringSubView: bringSubView)
  }
}


extension Reactive where Base: IntroViewController {
  var addLoginViewController: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.addLoginViewController()
    }
  }

  var addMainViewController: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.addMainViewController()
    }
  }
}
