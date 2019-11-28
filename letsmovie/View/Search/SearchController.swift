//
//  SearchController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 28/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class SearchMovieController: UITableViewController {
    
    private var searchController = SearchMovieController.searchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationController()
    }
}

//MARK:- UI Elements
extension SearchMovieController {
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
    }
    
    class func searchController() -> UISearchController {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }
}
