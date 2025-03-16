//
//  MovieDateTabItemModel.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import Foundation

struct MovieDateTabItemModel: Identifiable, Codable, Equatable {
  
    var id: String {
        self.date
    }
    let date: String
    let list: [MovieTimeTabItemModel]
}
