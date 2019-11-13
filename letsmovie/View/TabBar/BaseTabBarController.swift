//
//  BaseTabBarController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 13/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTabBarItems()
    }
    
    private func setupView() {
        view.backgroundColor = .clear
    }
    
    private func setupTabBarItems() {
        //MARK: DiscoverController
        let discoverController = DiscoverController()
        discoverController.tabBarItem.title = "Discover"

        //MARK: MeController
        let meController = MeController()
        meController.tabBarItem.title = "Me"
        
        viewControllers = [
            discoverController, meController
        ]
    }
}
