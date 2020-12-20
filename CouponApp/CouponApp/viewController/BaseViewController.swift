//
//  BaseViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/01.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BaseViewController: UIViewController, BaseBind {

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
  }

  open func bindInputs() {

  }

  open func bindOutpus() {

  }

  // MARK: - Etc Function

  fileprivate func showMainViewController() {
    let mainViewController: UIViewController = self.createViewController(storyboardName: CouponStoryBoardName.main.rawValue)
    mainViewController.modalPresentationStyle = .fullScreen
    self.present(mainViewController, animated: true, completion: nil)
  }

  fileprivate func showSignupViewController() {
    self.performSegue(withIdentifier:CouponIdentifier.showSignupViewController.rawValue, sender: nil)
  }
}

extension Reactive where Base: BaseViewController {

  var showMainViewController: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.showMainViewController()
    }
  }

  var showSignupViewController: Binder<Void> {
    return Binder(self.base) { view, _ in
      view.showSignupViewController()
    }
  }
}
