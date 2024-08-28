//
//  GameDetail.swift
//  Topaz
//
//  Created by Timmy Nguyen on 7/4/24.
//

import Foundation

struct GameResponse: Decodable {
    var data: GameDetail
    var success: Bool
}

struct GameDetail: Decodable {
    var name: String
    var description: String
    var backgroundURL: String
    var developers: [String]
    var publishers: [String]
    var categories: [GameCategory]
    var genres: [Genre]
    var screenshots: [Screenshot]
    var movies: [Movie]
    var releaseDate: ReleaseDate
    var recommendations: Recommendations
    
    enum CodingKeys: String, CodingKey {
        case name
        case description = "short_description"
        case backgroundURL = "background_raw"
        case developers
        case publishers
        case categories
        case genres
        case screenshots
        case movies
        case releaseDate = "release_date"
        case recommendations
    }
    
}

struct GameCategory: Decodable {
    var description: String
}

struct Genre: Decodable {
    var description: String
}

struct Screenshot: Decodable {
    var id: Int
    var thumbnailURL: String
    var regularURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case thumbnailURL = "path_thumbnail"
        case regularURL = "path_full"
    }
}

struct Movie: Decodable {
    var name: String
    var thumbnailURL: String
    var mp4: MP4
    
    enum CodingKeys: String, CodingKey {
        case name
        case thumbnailURL = "thumbnail"
        case mp4
    }
}

struct MP4: Decodable {
    var videoURL: String
    // var max: String
    
    enum CodingKeys: String, CodingKey {
        case videoURL = "480"
    }
}

struct ReleaseDate: Decodable {
    var date: String
}

struct Recommendations: Decodable {
    var total: Int
}
