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
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .systemGray
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.itemPositioning = .centered
    }

    private func setupTabBarItems() {
        //MARK: DiscoverController
        var discoverController = DiscoverController()
        discoverController.tabBarItem.image = UIImage(named: "eye")
        discoverController.tabBarItem.title = ""
        let discoverNavController = BackEnabledNavigationController(rootViewController: discoverController)
        
        let discoverViewModel = DiscoverViewModel(service: ApiManager.shared)
        discoverController.bind(viewModel: discoverViewModel)
        
        //MARK: SearchMovieController
        var searchController = SearchMovieController()
        searchController.tabBarItem.image = UIImage(named: "search")
        searchController.tabBarItem.title = ""
        let searchNavController = BackEnabledNavigationController(rootViewController: searchController)
        
        let searchMovieViewModel = SearchMovieViewModel(service: ApiManager.shared)
        searchController.bind(viewModel: searchMovieViewModel)
        
        //MARK: MeController
        var meController = MeController()
        meController.tabBarItem.image = UIImage(named: "user")
        meController.tabBarItem.title = ""
        let meNavController = UINavigationController(rootViewController: meController)
        
        let meViewModel = MeViewModel(service: ApiManager.shared, database: UserMovieStorage.shared)
        meController.bind(viewModel: meViewModel)
        
        viewControllers = [
            discoverNavController, searchNavController, meNavController
        ]
    }
    
    
    private func setInsetsTabBarItemsImage(with padding: UIEdgeInsets) {
        
        viewControllers?.forEach {
            $0.tabBarItem.imageInsets = padding
        }
    }
}
