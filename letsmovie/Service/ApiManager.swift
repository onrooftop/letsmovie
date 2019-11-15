//
//  ApiManager.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 15/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkSession {
    func request(router: Router) -> Single<[String: Any]>
}

class ApiManager: NetworkSession {
    static let shared = ApiManager()
    private init() {}
    
    func request(router: Router) -> Single<[String : Any]> {
        return Single.create { (single) -> Disposable in
            
            Alamofire.request(router).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    single(.success(value as! [String: Any]))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
