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
    private var userMovieList: ReplaySubject<Results<UserMovie>>
    
    private init() {
        realm = try! Realm()
//        print(".realm Location: [\(Realm.Configuration.defaultConfiguration.fileURL!)]")
        
        userMovieList = ReplaySubject<Results<UserMovie>>.create(bufferSize: 1)
        userMovieList.onNext(getUserMovieList())
    }
    
    
    
    @discardableResult
    func createOrUpdateUserMovie(userMovie: UserMovie) -> Observable<UserMovie> {
        
        try! realm.write {
            realm.add(userMovie, update: .modified)
        }
        userMovieList.onNext(getUserMovieList())
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
        
        userMovieList.onNext(getUserMovieList())
        
        return .just(newUserMovie)
    }
    
    @discardableResult
    func deleteUserMovie(userMovie: UserMovie) -> Observable<UserMovie> {
        try! realm.write {
            realm.delete(userMovie)
        }
        
        userMovieList.onNext(getUserMovieList())
        
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
        return userMovieList
    }
    
    private func getUserMovieList() -> Results<UserMovie> {
        return realm.objects(UserMovie.self)
            .sorted(byKeyPath: "lastEditDate", ascending: false)
    }
}
