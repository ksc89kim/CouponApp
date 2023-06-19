//
//  FindMerchantViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 28..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

/// 가맹점 찾기 뷰 컨트롤러
/// - 주변 가맹점, 전체 가맹점 찾는 뷰 컨트롤러
final class MerchantViewController: UIViewController {

  // MARK: - UI Component

  /// 상단 탭바 버튼  (주변 가맹점, 전체 가맹점)
  @IBOutlet var tabButtonArray: [UIButton] = []
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var selectLeadingLayout: NSLayoutConstraint!

  private lazy var pageController: UIPageViewController = {
    let pageController = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal,
      options: nil
    )

    if let firstViewController = self.viewControllers.first {
      pageController.setViewControllers(
        [firstViewController],
        direction: .forward,
        animated: false,
        completion: nil
      )
    }

    pageController.delegate = self
    pageController.dataSource = self

    return pageController
  }()

  private var viewControllers: [MerchantListViewController] = {
    var viewControllers: [MerchantListViewController] = []
    if let aroundMerchantTableViewController = ViewControllerFactory.createViewController(
      storyboardType: .merchant,
      identifierType: .aroundMerchantTableViewController
    ) as? AroundMerchantListViewController {
      aroundMerchantTableViewController.viewModel = AroundMerchantListViewModel()
      viewControllers.append(aroundMerchantTableViewController)
    }

    if let globalMerchantTableViewController = ViewControllerFactory.createViewController(
      storyboardType: .merchant,
      identifierType: .globalMerchantTableViewController
    ) as? GloabalMerchantListViewController {
      globalMerchantTableViewController.viewModel = MerchantListViewModel()
      viewControllers.append(globalMerchantTableViewController)
    }

    return viewControllers
  }()

  // MARK: - Property

  private var tabController: TabController?

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setPageViewController()
    self.setTabController()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Set Method

  private func setPageViewController() {
    let pageView = self.pageController.view
    pageView?.translatesAutoresizingMaskIntoConstraints = false
    self.addChild(self.pageController)
    self.view.addSubview(pageView!)
    self.pageController.didMove(toParent: self)

    pageView?.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
    pageView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    pageView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    pageView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
  }

  private func setTabController() {
    self.tabController = TabController(buttonArray: self.tabButtonArray)
    self.tabController?.callback = { [weak self] (button: UIButton) in
      self?.animationMoveTabView(button: button)
      self?.selectPageViewController(button: button)
    }
  }

  func setMerchantList(_ merchantList: any MerchantListable) {
    self.viewControllers.forEach { (tableViewController: MerchantListViewController) in
      tableViewController.viewModel?.inputs.merchantList.onNext(merchantList)
    }
  }

  // MARK: - TabView Move Animation

  private func animationMoveTabView(button: UIButton){
    self.selectLeadingLayout.constant = button.frame.origin.x
    UIView.animate(withDuration: 0.2, animations: {
      self.view.layoutIfNeeded()
    })
  }

  // MARK: - Selct Method

  private func selectPageViewController(button: UIButton) {
    let direction: UIPageViewController.NavigationDirection = (button.tag == 0) ? .reverse : .forward
    self.pageController.setViewControllers(
      [self.viewControllers[button.tag]],
      direction: direction,
      animated: true,
      completion: nil
    )
  }
}


extension MerchantViewController: UIPageViewControllerDelegate {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard finished,
          let firstViewController = pageViewController.viewControllers?.first as? MerchantListViewController,
          let index = self.viewControllers.index(of: firstViewController) else {
      return
    }

    self.tabController?.selectTab(index: index)
    self.animationMoveTabView(button: self.tabButtonArray[index])
  }
}


extension MerchantViewController: UIPageViewControllerDataSource {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let merchantListViewController = viewController as? MerchantListViewController,
          let index = self.viewControllers.index(of: merchantListViewController) else {
      return nil
    }
    let previousIndex = index - 1
    guard self.viewControllers.indices ~= previousIndex else { return nil }
    return self.viewControllers[previousIndex]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let merchantListViewController = viewController as? MerchantListViewController,
          let index = self.viewControllers.index(of: merchantListViewController) else {
      return nil
    }
    let nextIndex = index + 1
    guard self.viewControllers.indices ~= nextIndex else { return nil }
    return self.viewControllers[nextIndex]
  }
}
