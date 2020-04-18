//
//  TabController.swift
//  CouponApp
//
//  Created by kim sunchul on 13/07/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

typealias TabCallBack = (UIButton) -> Void

class TabController {
    let tabButtonArray:[UIButton]?
    var currentIndex:Int = 0
    var callback:TabCallBack?

    init(buttonArray:[UIButton]){
        self.tabButtonArray = buttonArray
        for i in 0 ..< tabButtonArray!.count {
            let button:UIButton = tabButtonArray![i] as UIButton
            button.tag = i
            button.addTarget(self, action: #selector(onTab(button:)), for: .touchUpInside)
        }
        
        self.selectTab(index: currentIndex)
        self.executeCallBack(button:tabButtonArray![currentIndex])
    }
    
    @objc func onTab(button:UIButton) {
        self.selectTab(button: button)
        self.executeCallBack(button: button)
    }
    
    func selectTab(index:Int) {
        guard let buttonArray = tabButtonArray else {
            print("tabButtonArray nil")
            return
        }
        
        selectTab(button: buttonArray[index])
    }
    
    func selectTab(button:UIButton) {
        for tabButton in tabButtonArray! {
            if button == tabButton {
                tabButton.isSelected = true
                currentIndex = tabButton.tag
            } else {
                tabButton.isSelected = false
            }
        }
    }
    
    func executeCallBack(button:UIButton) {
        guard let tabCallback = callback else {
            print("callback nil")
            return
        }
        
        tabCallback(button)
    }
}
