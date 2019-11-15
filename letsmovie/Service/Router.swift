//
//  Router.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 15/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case movie(id: String, appendToResponses: [appendToResponseType])
    case popular(page: Int)
    case nowPlaying(page: Int)
    case upcoming(page: Int)
    
    enum appendToResponseType: String {
        case videos, credits
    }
    
    var path: String {
        switch self {
        case .movie(let id, let appendToResponses):
            if appendToResponses.isEmpty {
                return "/movie/\(id)"
            } else {
                let appendToResponseString = appendToResponses.map{ $0.rawValue }
                let appendToResponseOneString = appendToResponseString.joined(separator: ",")
                return "/movie/\(id)&?append_to_response=\(appendToResponseOneString)"
            }
        case .popular(let page):
            return "/movie/popular?page=\(page)"
        case .nowPlaying(let page):
            return "/movie/now_playing?page=\(page)"
        case .upcoming(let page):
            return "movie/upcoming?page=\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .movie:
            return .get
        case .popular:
            return .get
        case .nowPlaying:
            return .get
        case .upcoming:
            return .get
        }
    }
    
    private func addDefaultHttpHeader(_ urlRequest: inout URLRequest) {
        urlRequest.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(API_READ_ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseUrl = "https://api.themoviedb.org/3"
        let url = URL(string: baseUrl + path)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        addDefaultHttpHeader(&urlRequest)
        return urlRequest
    }
}
