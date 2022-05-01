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

  //MARK: - UI Component

  @IBOutlet var tabButtonArray: [UIButton] = [] //상단 탭바 버튼  (주변 가맹점, 전체 가맹점)
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var selectLeadingLayout: NSLayoutConstraint!

  private lazy var pageController: UIPageViewController = {
    let pageController = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal,
      options: nil
    )

    if let firstViewController = self.viewControllerArray.first {
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

  lazy var viewControllerArray:[UIViewController] = {
    let globalMerchantTableViewController = self.createViewController(
      storyboardName: CouponStoryBoardName.merchant.rawValue,
      withIdentifier: CouponIdentifier.globalMerchantTableViewController.rawValue
    )
    let aroundMerchantTableViewController = self.createViewController(
      storyboardName: CouponStoryBoardName.merchant.rawValue,
      withIdentifier: CouponIdentifier.aroundMerchantTableViewController.rawValue
    )
    return [aroundMerchantTableViewController, globalMerchantTableViewController]
  }()

  //MARK: - Property

  private var tabController: TabController?

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setPageViewController()
    self.setTabController()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK: - Set Method

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

  //MARK: - TabView Move Animation

  private func animationMoveTabView(button: UIButton){
    self.selectLeadingLayout.constant = button.frame.origin.x
    UIView.animate(withDuration: 0.2, animations: {
      self.view.layoutIfNeeded()
    })
  }

  //MARK: - Selct Method

  private func selectPageViewController(button: UIButton) {
    let direction: UIPageViewController.NavigationDirection = (button.tag == 0) ? .reverse : .forward
    self.pageController.setViewControllers(
      [self.viewControllerArray[button.tag]],
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
    if finished {
      guard let vcIndex = self.viewControllerArray.index(
        of: (pageViewController.viewControllers?.first)!
      )
      else {
        return
      }
      self.tabController?.selectTab(index: vcIndex)
      self.animationMoveTabView(button: self.tabButtonArray[vcIndex])
    }
  }
}


extension MerchantViewController: UIPageViewControllerDataSource {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let vcIndex = self.viewControllerArray.index(of: viewController) else {
      return nil
    }
    let previousIndex = vcIndex - 1
    guard previousIndex > -1 else { return nil }
    return self.viewControllerArray[previousIndex]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let vcIndex = self.viewControllerArray.index(of: viewController) else { return nil }
    let nextIndex = vcIndex + 1
    guard self.viewControllerArray.count > nextIndex else { return nil }
    return self.viewControllerArray[nextIndex]
  }
}
