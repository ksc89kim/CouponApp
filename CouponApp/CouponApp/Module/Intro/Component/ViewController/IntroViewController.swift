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

  @Inject(IntroViewModelKey.self)
  private var introViewModel: IntroViewModelType

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()


    self.introViewModel.inputs.loadMerchantData.onNext(())

    self.stampView.completion = { [weak self] in
      self?.fadeAnimation()
    }
  }

  // MARK: - Bind

  override func bindInputs() {
    super.bindInputs()
  }

  override func bindOutputs() {
    super.bindOutputs()

    self.introViewModel.outputs?
      .addLoginViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.addLoginViewController)
      .disposed(by: self.disposeBag)

    self.introViewModel.outputs?
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

  fileprivate func addLoginViewController(merchantList: MerchantList) {
    guard let bringSubView = self.backgroundView else {
      print("showLoginViewController - backgorundView nil")
      return
    }

    let loginNavigationController = ViewControllerFactory.createViewController(
      storyboardType: .start,
      identifierType: .loginNavigationController
    )

    let baseViewController = loginNavigationController.children.first { (viewController: UIViewController) -> Bool in
      return viewController is LoginViewController
    }

    if let loginViewController = baseViewController as? LoginViewController {
      loginViewController.merchantList = merchantList
    }

    self.addViewController(viewController: loginNavigationController, bringSubView: bringSubView)
  }

  fileprivate func addMainViewController(merchantList: MerchantList) {
    guard let bringSubView = self.backgroundView else {
      print("showMainViewController - backgorundView nil")
      return
    }

    let mainViewController = ViewControllerFactory.createViewController(storyboardType: .main)
    if let merchantTabBarController = mainViewController as? MerchantTabBarController {
      let userMerchantViewController = merchantTabBarController.usermerchant
      let viewModel = UserMerchantViewModel()
      viewModel.inputs.merchantList.onNext(merchantList)
      userMerchantViewController?.viewModel = viewModel
      merchantTabBarController.merchant?.setMerchantList(merchantList)
    }
    self.addViewController(viewController: mainViewController, bringSubView: bringSubView)
  }
}


extension Reactive where Base: IntroViewController {
  var addLoginViewController: Binder<MerchantList> {
    return Binder(self.base) { view, merchantList in
      view.addLoginViewController(merchantList: merchantList)
    }
  }

  var addMainViewController: Binder<MerchantList> {
    return Binder(self.base) { view, merchantList in
      view.addMainViewController(merchantList: merchantList)
    }
  }
}
