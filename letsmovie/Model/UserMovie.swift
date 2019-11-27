//
//  UserMovie.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 27/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RealmSwift



class UserMovie: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var posterUrlPath: String? = nil
    @objc dynamic var privateUserMovieStatus: Int = UserMovieStatus.none.rawValue
    var userMovieStatus: UserMovieStatus {
        get { return UserMovieStatus.init(rawValue: privateUserMovieStatus)! }
        set { privateUserMovieStatus = newValue.rawValue }
    }
    @objc dynamic var lastEditDate: Date = Date()
    
    
    enum UserMovieStatus: Int {
        case none, watchlist, watched
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
