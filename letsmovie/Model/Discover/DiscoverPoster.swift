//
//  DiscoverPoster.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 18/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation

struct DiscoverPoster: Decodable {
    let page: Int
    let totalPages: Int
    let results: [DiscoverResult]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

struct DiscoverResult: Decodable {
    let id: Int
    let posterPath: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
    }
}
