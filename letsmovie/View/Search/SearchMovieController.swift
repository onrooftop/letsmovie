//
//  SearchController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 28/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchMovieController: UITableViewController, UsableViewModel {
    private let disposeBag = DisposeBag()
    
    private var searchController = SearchMovieController.searchController()
    private var noMoviesMessage = SearchMovieController.noMoviesMessage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationController()
        setupTableView()
    }
    
    var viewModel: SearchMovieViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? SearchMovieViewModel)
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        searchController.searchBar
            .rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.searchResults
            .bind(to: tableView.rx.items(cellIdentifier: SearchMovieCellViewModel.cellIdentifier)) {
                (row, cellViewModel, cell) in
                
                if var cell = cell as? ViewModelBindableType {
                    cell.bind(viewModel: cellViewModel)
                }
                
                self.viewModel.row.onNext(row)
            }
            .disposed(by: disposeBag)
        
        viewModel.isFooterHidden
            .bind(to: tableView.tableFooterView!.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isFooterHidden
            .subscribe(onNext: { (isHidden) in
                self.tableView.tableFooterView!.frame = isHidden ? .zero : CGRect(x: 0, y: 0, width: 0, height: 50)
            })
            .disposed(by: disposeBag)
        
        viewModel.isNoMoivesMessageHidden
            .bind(to: noMoviesMessage.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.selectedViewModel
            .subscribe(onNext: { [unowned self] (viewModel) in
                var movieController = MovieController()
                movieController.hidesBottomBarWhenPushed = true
                movieController.bind(viewModel: viewModel)
                self.navigationController?.pushViewController(movieController, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx.itemSelected
            .bind(to: viewModel.selectedItem.inputs)
            .disposed(by: disposeBag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
}

//MARK:- UI Elements
extension SearchMovieController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(noMoviesMessage)
        noMoviesMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noMoviesMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noMoviesMessage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)
        ])
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
    class func noMoviesMessage() -> UILabel {
        let lb = UILabel()
        lb.textColor = .systemGray
        lb.font = .systemFont(ofSize: 18)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.text = "There are no movies\nin this search list"
        return lb
    }
    
    class func searchController() -> UISearchController {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.tintColor = .systemGray
        sc.searchBar.autocapitalizationType = .none
        sc.searchBar.placeholder = "Title"
        return sc
    }
}

//MARK:- TableView
extension SearchMovieController {
    private func setupTableView() {
        tableView.register(SearchMovieCell.self, forCellReuseIdentifier: SearchMovieCellViewModel.cellIdentifier)
        
        tableView.separatorInset = .init(top: 0, left: 30, bottom: 0, right: 30)
        
        tableView.tableFooterView = FooterView()
    }
}
