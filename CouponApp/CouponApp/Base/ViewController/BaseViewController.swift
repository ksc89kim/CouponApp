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

  var viewModel: ViewModelType?


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

  fileprivate func showMainViewController(merchantList: any MerchantListable) {
    let mainViewController = ViewControllerFactory.createViewController(storyboardType: .main)
    mainViewController.modalPresentationStyle = .fullScreen
    if let merchantTabBarController = mainViewController as? MerchantTabBarController {
      let userMerchantViewController = merchantTabBarController.usermerchant
      let viewModel = UserMerchantViewModel()
      viewModel.inputs.merchantList.onNext(merchantList)
      userMerchantViewController?.viewModel = viewModel
      merchantTabBarController.merchant?.setMerchantList(merchantList)
    }
    self.present(mainViewController, animated: true, completion: nil)
  }
}


extension Reactive where Base: BaseViewController {

  var showMainViewController: Binder<any MerchantListable> {
    return Binder(self.base) { view, merchantList in
      view.showMainViewController(merchantList: merchantList)
    }
  }
}
