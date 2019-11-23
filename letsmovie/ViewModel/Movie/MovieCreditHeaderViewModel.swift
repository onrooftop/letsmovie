//
//  MovieCreditHeaderViewModel.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift

enum CreditType: String {
    case cast = "Cast", crew = "Crew"
}

class MovieCreditHeaderViewModel: ViewModelType, CellIdentifier {
    
    static var cellIdentifier: String = "MovieCreditHeaderViewModel"
    
    let title: Observable<String>
    
    private let creditType: CreditType
    init(creditType: CreditType) {
        self.creditType = creditType
        
        title = .just(self.creditType.rawValue)
    }
}
