//
//  CouponViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/01.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxCocoa
import RxSwift

class CouponViewController: UIViewController {

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
  }

  open func bind() {

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

extension Reactive where Base: CouponViewController {

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
