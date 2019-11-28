//
//  SearchMovieCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 28/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchMovieCell: UITableViewCell, UsableViewModel {
    private let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var viewModel: SearchMovieCellViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? SearchMovieCellViewModel)
        
        viewModel.movieTitle
            .bind(to: textLabel!.rx.text)
            .disposed(by: disposeBag)
    }
}
