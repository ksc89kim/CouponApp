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
final class IntroViewController: UIViewController {

  // MARK: - UI Component

  @IBOutlet weak var stampView: IntroStampView!
  @IBOutlet weak var backgroundView: UIView!

  // MARK: - Property

  let viewModel = IntroViewModel()
  let disposeBag = DisposeBag()

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.bind()

    self.viewModel.action.loadMerchantData.onNext(())

    self.stampView.completion = { [weak self] in
      self?.fadeAnimation()
    };
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  // MARK: - Bind

  private func bind() {
    self.viewModel.state
      .showLoginviewcontroller
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showLoginViewController)
      .disposed(by: self.disposeBag)

    self.viewModel.state
      .showMainViewController
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.showMainViewController)
      .disposed(by: self.disposeBag)
  }

  // MARK: - Animation Function

  private func fadeAnimation() {
    self.backgroundView.alpha = 1
    UIView.animate(withDuration: 0.3,
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

  fileprivate func showLoginViewController() {
    guard let bringSubView = self.backgroundView else {
      print("showLoginViewController - backgorundView nil")
      return
    }

    let loginViewController =  self.createViewController(storyboardName: CouponStoryBoardName.start.rawValue, withIdentifier:CouponIdentifier.loginNavigationController.rawValue)
    self.addViewController(viewController: loginViewController,bringSubView:bringSubView)
  }

  fileprivate func showMainViewController() {
    guard let bringSubView = self.backgroundView else {
      print("showMainViewController - backgorundView nil")
      return
    }

    let mainViewcontroller =  self.createViewController(storyboardName: CouponStoryBoardName.main.rawValue)
    self.addViewController(viewController: mainViewcontroller,bringSubView:bringSubView)
  }
}


extension Reactive where Base: IntroViewController {
  var showLoginViewController: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.showLoginViewController()
    }
  }

  var showMainViewController: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.showMainViewController()
    }
  }
}
