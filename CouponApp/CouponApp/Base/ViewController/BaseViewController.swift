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

open class BaseViewController: UIViewController, Bindable {

  // MARK: - Property

  let disposeBag = DisposeBag()

  // MARK: - Init

  init(nibType: CouponNibName) {
    super.init(nibName: nibType.rawValue, bundle: nil)
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  // MARK: - Life Cycle

  open override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
  }

  // MARK: - Bind

  open func bindInputs() {

  }

  open func bindOutputs() {

  }

  // MARK: - Etc Method

  fileprivate func showMainViewController() {
    let mainViewController: UIViewController = self.createViewController(storyboardType: .main)
    mainViewController.modalPresentationStyle = .fullScreen
    self.present(mainViewController, animated: true, completion: nil)
  }

  fileprivate func showSignupViewController() {
    self.performSegue(withIdentifier: CouponIdentifier.showSignupViewController.rawValue, sender: nil)
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
