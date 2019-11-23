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

//MARK:- Image URL
extension ApiManager {
    private static let secureBaseUrl = "https://image.tmdb.org/t/p/"
    
    static func imageUrl(path: String?, size: String) -> URL? {
        guard let path = path else { return nil }
        let urlString = secureBaseUrl + size + path
        return URL(string: urlString)
    }
    
    enum PosterSize: String {
        case w342, w780, original
    }
    
    static func posterImageUrl(posterPath: String?, posterSize: PosterSize = .w342) -> URL? {
        return imageUrl(path: posterPath, size: posterSize.rawValue)
    }

    enum ProfileSize: String {
        case w92, w342, original
    }
    
    static func profileImageUrl(profilePath: String?, profileSize: ProfileSize = .w92) -> URL? {
        return imageUrl(path: profilePath, size: profileSize.rawValue)
    }
}
enum DataError: Error {
    case cantDecode
}
