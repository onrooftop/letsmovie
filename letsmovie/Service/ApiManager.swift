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

typealias JSON = [String: Any]

protocol NetworkSession {
    func request(router: Router) -> Single<Data>
    func request(discoverType: DiscoverType, page: Int) -> Single<Data>
}

class ApiManager: NetworkSession {
    static let shared = ApiManager()
    private init() {}
    
    private let secureBaseUrl = "https://image.tmdb.org/t/p/"
    private let posterSize = "w342"
    
    func posterImageUrl(posterPath: String) -> URL? {
        return URL(string: secureBaseUrl + posterSize + posterPath)
    }
    
    func request(router: Router) -> Single<Data> {
        return Single.create { (single) -> Disposable in
            
            Alamofire.request(router).responseJSON { (response) in
                switch response.result {
                case .success:
                    single(.success(response.data!))
                case .failure(let error):
                    single(.error(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func request(discoverType: DiscoverType, page: Int) -> Single<Data> {
        var router: Router
        switch discoverType {
        case .popular:
            router = Router.popular(page: page)
        case .nowPlaying:
            router = Router.nowPlaying(page: page)
        case .upComing:
            router = Router.upcoming(page: page)
        }
        
        return self.request(router: router)
        
    }
}

enum DataError: Error {
    case cantDecode
}
