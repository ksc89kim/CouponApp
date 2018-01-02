//
//  FindMerchantViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 28..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

class FindMerchantViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageController:UIPageViewController?
    lazy var viewControllerList:[UIViewController] = {
        let storyBoard = UIStoryboard(name:"FindMerchantPageView", bundle:Bundle.main)
        let publicMerchantTableViewController = storyBoard.instantiateViewController(withIdentifier: "publicMerchantTableView")
        let nearMerchantTableViewController = storyBoard.instantiateViewController(withIdentifier: "nearMerchantTableView")
        return [publicMerchantTableViewController,nearMerchantTableViewController]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let firstViewController = viewControllerList.first {
            pageController!.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        let mainView = self.view.viewWithTag(1)
        let topView = mainView?.viewWithTag(1)
        let pageView = self.pageController!.view
        pageView?.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(pageController!)
        mainView?.addSubview(pageView!)
        
        let pageViewWidthLayout = NSLayoutConstraint(item: pageView!, attribute: .width, relatedBy: .equal,
                                                     toItem: mainView, attribute: .width, multiplier: 1, constant: 0)
        let pageViewCenterLayout = NSLayoutConstraint(item: pageView!, attribute: .centerX, relatedBy: .equal,
                                                      toItem: mainView, attribute: .centerX, multiplier: 1, constant: 0)
        let pageViewTopLayout = NSLayoutConstraint(item: pageView!, attribute: .top, relatedBy: .equal,
                                                   toItem: topView, attribute: .top, multiplier: 1, constant: 30)
        let pageViewBottomLayout = NSLayoutConstraint(item: pageView!, attribute: .bottom, relatedBy: .equal,
                                                      toItem: mainView, attribute: .bottom, multiplier: 1, constant: 0)
        mainView?.addConstraints([pageViewWidthLayout,pageViewCenterLayout,pageViewTopLayout,pageViewBottomLayout])
        
        pageController?.delegate = self
        pageController?.dataSource = self
        pageController!.didMove(toParentViewController: self)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex > 0 else { return nil }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
