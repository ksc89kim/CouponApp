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

  private var introViewModel: IntroViewModelType? {
    return self.viewModel as? IntroViewModelType
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()


    self.introViewModel?.inputs.loadMerchantData.onNext(())

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

    self.introViewModel?.outputs?
      .addLoginViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.addLoginViewController)
      .disposed(by: self.disposeBag)

    self.introViewModel?.outputs?
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

    let loginViewController = self.createBaseViewController(
      storyboardType: .start,
      identifierType: .loginNavigationController
    )
    loginViewController?.viewModel = LoginViewModel()
    if let viewController = loginViewController {
      self.addViewController(viewController: viewController, bringSubView: bringSubView)
    }
  }

  fileprivate func addMainViewController() {
    guard let bringSubView = self.backgroundView else {
      print("showMainViewController - backgorundView nil")
      return
    }

    let mainViewController = self.createViewController(storyboardType: .main)
    mainViewController.children.forEach { (viewController: UIViewController) in
      viewController.children.forEach { (viewController: UIViewController) in
        if let userMerchantViewController = viewController as?  UserMerchantTableViewController {
          userMerchantViewController.viewModel = UserMerchantViewModel()
        }
      }
    }
    self.addViewController(viewController: mainViewController, bringSubView: bringSubView)
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
