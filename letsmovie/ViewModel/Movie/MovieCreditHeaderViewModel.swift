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
    
    let credit: Observable<String>
    
    private let creditType: CreditType
    init(creditType: CreditType) {
        self.creditType = creditType
        
        credit = .just(self.creditType.rawValue)
    }
}
