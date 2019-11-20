//
//  BackEnabledNavigationController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 19/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    var isHiddenStatusBar = false
    var statusBarStyle: UIStatusBarStyle = .default
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let _ = viewController as? MovieController {
            self.statusBarStyle = .lightContent
            self.isHiddenStatusBar = true
        } else {
            self.statusBarStyle = .default
            self.isHiddenStatusBar = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        self.statusBarStyle = .default
        self.isHiddenStatusBar = false
        return super.popViewController(animated: animated)
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHiddenStatusBar
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
