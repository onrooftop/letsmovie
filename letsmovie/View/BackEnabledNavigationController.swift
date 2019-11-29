//
//  BackEnabledNavigationController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 19/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactivePopGestureRecognizer?.delegate = self
        
        print("viewDidAppear")
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }

    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
