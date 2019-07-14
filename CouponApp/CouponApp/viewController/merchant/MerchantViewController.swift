//
//  FindMerchantViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 28..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

/*
     가맹점 찾기 뷰 컨트롤러
     - 주변 가맹점, 전체 가맹점 찾는 뷰 컨트롤러
 */
class MerchantViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    @IBOutlet var tabButtonArray:[UIButton] = [] //상단 탭바 버튼  (주변 가맹점, 전체 가맹점)
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var selectLeadingLayout: NSLayoutConstraint!

    var currentTabBtn:UIButton? // 현재 등록된 탭 버튼
    var pageController:UIPageViewController? // 페이지 컨트롤러
    var tabController:TabController?
    
    lazy var viewControllerArray:[UIViewController] = {
        let areasTableViewController = self.createViewController(storyboardName: CouponStoryBoardName.merchant.rawValue, withIdentifier: CouponIdentifier.areasTableViewController.rawValue)
        let aroundTableViewController = self.createViewController(storyboardName: CouponStoryBoardName.merchant.rawValue, withIdentifier: CouponIdentifier.aroundTableViewController.rawValue)
        return [aroundTableViewController,areasTableViewController]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPageViewController()
        self.setTabController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPageViewController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let firstViewController = viewControllerArray.first {
            pageController!.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        
        let pageView = self.pageController!.view
        pageView?.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(pageController!)
        self.view.addSubview(pageView!)
        
        pageView?.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        pageView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pageView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        pageController?.delegate = self
        pageController?.dataSource = self
        pageController!.didMove(toParentViewController: self)
    }
    
    func setTabController() {
        tabController = TabController(buttonArray: tabButtonArray)
        tabController?.callback = { [weak self] (button:UIButton) in
            self?.animationMoveTabView(button: button)
            self?.selectPageViewController(button: button)
        }
    }
    
    //MARK - PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerArray.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex > -1 else { return nil }
        return viewControllerArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerArray.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerArray.count > nextIndex else { return nil }
        return viewControllerArray[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            guard let vcIndex = viewControllerArray.index(of: (pageViewController.viewControllers?.first)!) else { return }
            tabController?.selectTab(index: vcIndex)
            self.animationMoveTabView(button:tabButtonArray[vcIndex])
        }
    }
    
    func selectPageViewController(button:UIButton) {
        let direction:UIPageViewController.NavigationDirection = (button.tag == 0) ? .reverse : .forward
        pageController!.setViewControllers([viewControllerArray[button.tag]], direction: direction, animated: true, completion: nil)
    }
    
    //MARK - TabView Move Animation
    func animationMoveTabView(button:UIButton){
        selectLeadingLayout.constant = button.frame.origin.x
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }

}
