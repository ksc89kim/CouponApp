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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let publicFindMerchantTableView = viewControllerAtIndex(index: 0)!
        let viewControllers:[UIViewController] = [publicFindMerchantTableView]
        let mainView = self.view.viewWithTag(1)
        let topView = mainView?.viewWithTag(1)
        let pageView = self.pageController!.view
        pageView?.translatesAutoresizingMaskIntoConstraints = false
        pageController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
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
        pageController?.view.backgroundColor = UIColor.black
        pageController!.didMove(toParentViewController: self)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index:Int) -> UIViewController? {
        let storyBoard = UIStoryboard(name:"FindMerchantPageView", bundle:Bundle.main)
        let dataViewControler = storyBoard.instantiateViewController(withIdentifier: "publicMerchantTableView")
        return dataViewControler
    }
    
    
    //MARK - PageViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewControllerAtIndex(index: 0)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewControllerAtIndex(index: 0)
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
