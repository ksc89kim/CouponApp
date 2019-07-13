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
class FindMerchantViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet var tabButtonList:[UIButton] = [] //상단 탭바 버튼  (주변 가맹점, 전체 가맹점)
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var selectLeadingLayout: NSLayoutConstraint!

    var currentTabBtn:UIButton? // 현재 등록된 탭 버튼
    var pageController:UIPageViewController? // 페이지 컨트롤러
    
    lazy var viewControllerList:[UIViewController] = {
        let storyBoard = UIStoryboard(name:"Merchant", bundle:Bundle.main)
        let publicMerchantTableViewController = storyBoard.instantiateViewController(withIdentifier: "publicMerchantTableView")
        let nearMerchantTableViewController = storyBoard.instantiateViewController(withIdentifier: "nearMerchantTableView")
        return [nearMerchantTableViewController,publicMerchantTableViewController]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        currentTabBtn = tabButtonList[0]
        currentTabBtn?.isSelected = true
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let firstViewController = viewControllerList.first {
            pageController!.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        
        let pageView = self.pageController!.view
        pageView?.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(pageController!)
        self.view.addSubview(pageView!)
        
        let pageViewWidthLayout = NSLayoutConstraint(item: pageView!, attribute: .width, relatedBy: .equal,
                                                     toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
        
        let pageViewCenterLayout = NSLayoutConstraint(item: pageView!, attribute: .centerX, relatedBy: .equal,
                                                      toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let pageViewTopLayout = NSLayoutConstraint(item: pageView!, attribute: .top, relatedBy: .equal,
                                                   toItem: topView, attribute: .bottom, multiplier: 1, constant:0)
        
        let pageViewBottomLayout = NSLayoutConstraint(item: pageView!, attribute: .bottom, relatedBy: .equal,
                                                      toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([pageViewWidthLayout,pageViewCenterLayout,pageViewTopLayout,pageViewBottomLayout])
        
        pageController?.delegate = self
        pageController?.dataSource = self
        pageController!.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex > -1 else { return nil }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            guard let vcIndex = viewControllerList.index(of: (pageViewController.viewControllers?.first)!) else { return }
            refreshTabBtn(vcIndex)
        }
    }
    
    //MARK - 상단 탭 버튼
    @IBAction func onTab(_ sender: Any) {
        let selectBtn:UIButton = sender as! UIButton
        if !selectBtn.isSelected {
            if selectBtn.tag > (self.currentTabBtn?.tag)! {
                pageController!.setViewControllers([viewControllerList[selectBtn.tag-1]], direction: .forward, animated: true, completion: nil)
            } else {
                pageController!.setViewControllers([viewControllerList[selectBtn.tag-1]], direction: .reverse, animated: true, completion: nil)
            }
        }
        refreshTabBtn(selectBtn.tag-1)
    }
    
    // 상단 탭 버튼 리프레시
    func refreshTabBtn(_ index:Int) {
        guard index < tabButtonList.count  && index > -1 else {
            return
        }
        
        for i in 0 ..< tabButtonList.count  {
            let tabBtn = tabButtonList[i]
            if i == index {
                if !tabBtn.isSelected {
                    tabBtn.isSelected = true
                    animationSelectTabView(button: tabBtn)
                }
                self.currentTabBtn = tabBtn
            } else {
                tabButtonList[i].isSelected = false
            }
        }
    }
    
    func animationSelectTabView(button:UIButton){
        selectLeadingLayout.constant = button.frame.origin.x
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }

}
