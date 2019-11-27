//
//  UserMovieStorage.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 27/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

protocol UserMovieStorageType {
    @discardableResult
    func createOrUpdateUserMovie(userMovie: UserMovie) -> Observable<UserMovie>
    
    @discardableResult
    func deleteUserMovie(userMovie: UserMovie) -> Observable<UserMovie>
    
    @discardableResult
    func findUserMovie(by id: Int) -> Observable<UserMovie?>
    
    @discardableResult
    func UserMovieList() -> Observable<Results<UserMovie>>
    
    @discardableResult
    func updateUserMovieStatus(by id: Int, with status: UserMovie.UserMovieStatus) -> Observable<UserMovie?>
}

class UserMovieStorage: UserMovieStorageType {
    
    var realm: Realm!
    static let shared = UserMovieStorage()
    private init() {
        realm = try! Realm()
        print(".realm Location: [\(Realm.Configuration.defaultConfiguration.fileURL!)]")
    }
    
    @discardableResult
    func createOrUpdateUserMovie(userMovie: UserMovie) -> Observable<UserMovie> {
        
        try! realm.write {
            realm.add(userMovie, update: .modified)
        }
        
        return Observable.just(userMovie)
    }
    
    @discardableResult
    func updateUserMovieStatus(by id: Int, with status: UserMovie.UserMovieStatus) -> Observable<UserMovie?> {
        
        let newUserMovie = UserMovie()
        newUserMovie.id = id
        
        let userMovie = realm.objects(UserMovie.self)
            .filter { $0.id == id }
            .first
        
        guard userMovie != nil else {
            return .just(nil)
        }
        
        newUserMovie.userMovieStatus = status
        newUserMovie.lastEditDate = Date()
        newUserMovie.posterUrlPath = userMovie!.posterUrlPath
        createOrUpdateUserMovie(userMovie: newUserMovie)
        return .just(newUserMovie)
    }
    
    @discardableResult
    func deleteUserMovie(userMovie: UserMovie) -> Observable<UserMovie> {
        try! realm.write {
            realm.delete(userMovie)
        }
        return Observable.just(userMovie)
    }
    
    @discardableResult
    func findUserMovie(by id: Int) -> Observable<UserMovie?> {
        let userMovie = realm.objects(UserMovie.self)
            .filter { $0.id == id }
            .first
        
        return .just(userMovie)
        
    }
    
    @discardableResult
    func UserMovieList() -> Observable<Results<UserMovie>> {
        return .just(realm.objects(UserMovie.self))
    }
}
