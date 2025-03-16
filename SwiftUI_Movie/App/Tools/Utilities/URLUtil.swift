//
//  URLUtil.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/12/31.
//

import Foundation

struct URLUtil {
    
    static func getMovieList(page: String, tab: String) -> URL {
        Defaults.URL.macros.appending(queryItems: [.page: page, .type: "MovieList", .tab: tab])
    }
    static func getTheaterList() -> URL {
        Defaults.URL.macros.appending(queryItems: [.type: "Area"])
    }
    static func getTheaterResultList(cinema_id: String) -> URL {
        Defaults.URL.macros.appending(queryItems: [.cinema_id: cinema_id, .type: "TheaterResult"])
    }
    static func getMovieInfo(movie_id: String) -> URL {
        Defaults.URL.macros.appending(queryItems: [.movie_id: movie_id, .type: "MovieInfo"])
    }
    static func getStoreInfo(movie_id: String) -> URL {
        Defaults.URL.macros.appending(queryItems: [.movie_id: movie_id, .type: "StoreInfo"])
    }
    static func getMovieDateResult(movie_id: String) -> URL {
        Defaults.URL.macros.appending(queryItems: [.movie_id: movie_id, .type: "MovieTime"])
    }
    static func getVideo(movie_id: String) -> URL {
        Defaults.URL.macros.appending(queryItems: [.movie_id: movie_id, .type: "Video"])
    }
}
