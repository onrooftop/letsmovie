//
//  BaseTabBarController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 13/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    let tabBarItemPadding: UIEdgeInsets = .init(top: 10, left: 0, bottom: -10, right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTabBarItems()
        setInsetsTabBarItemsImage(with: tabBarItemPadding)
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        tabBar.tintColor = .darkGray
    }
    
    private func setupTabBarItems() {
        //MARK: DiscoverController
        let discoverController = DiscoverController()
        discoverController.tabBarItem.image = UIImage(named: "eye")
        discoverController.tabBarItem.title = ""

        //MARK: MeController
        let meController = MeController()
        meController.tabBarItem.image = UIImage(named: "user")
        meController.tabBarItem.title = ""
        let meNavController = UINavigationController(rootViewController: meController)
        
        viewControllers = [
            discoverController, meNavController
        ]
    }
    
    private func setInsetsTabBarItemsImage(with padding: UIEdgeInsets) {
        
        viewControllers?.forEach {
            $0.tabBarItem.imageInsets = padding
        }
    }
}
