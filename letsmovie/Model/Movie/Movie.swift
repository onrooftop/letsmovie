//
//  Movie.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 23/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let backdropPath: String
    let genres: [Genre]
    let overview: String
    let runtime: Int
    let title: String
    let credits: Credits
    
    enum CodingKeys: String, CodingKey {
        case genres, overview, runtime, title, credits
        case backdropPath = "backdrop_path"
    }
    
    struct Genre: Decodable {
        let name: String
    }
    
    struct Credits: Decodable {
        let cast: [Cast]
        let crew: [Crew]
    }
    
    struct Cast: Decodable {
        let character: String
        let name: String
        let profilePath: String?
        
        enum CodingKeys: String, CodingKey {
            case character, name
            case profilePath = "profile_path"
        }
    }
    
    struct Crew: Decodable {
        let name: String
        let job: String
        let profilePath: String?
        
        enum CodingKeys: String, CodingKey {
            case name, job
            case profilePath = "profile_path"
        }
    }
}
