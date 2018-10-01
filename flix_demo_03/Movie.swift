//
//  Movie.swift
//  flix_demo_03
//
//  Created by Chengjiu Hong on 9/30/18.
//  Copyright © 2018 Chengjiu Hong. All rights reserved.
//

import Foundation

class Movie{
    var title: String
    var overview: String
    var posterURL: URL?
    var backdropURL: URL?
    var releaseDate: String
    
    init(dictionary: [String:Any]){
        title = dictionary["title"] as? String ?? "No Title"
        overview = dictionary["overview"] as? String ?? "No Overview"
        releaseDate=dictionary["release_date"] as? String ?? "No Release Date"
        
        let posterPathString = dictionary["poster_path"] as! String
        let backdropPathString = dictionary["backdrop_path"] as! String
        
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        posterURL = URL(string: baseURLString + posterPathString)!
        backdropURL = URL(string: baseURLString + backdropPathString)!
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
