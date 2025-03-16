//
//  MovieListModel.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/1/31.
//

import Foundation

public struct MovieListModel: Identifiable, Codable, Equatable {
  
    let title: String
    let en: String
    let release_movie_time: String
    let thumb: String
    public let id: String
}

