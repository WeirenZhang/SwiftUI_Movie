//
//  MovieTimeTabItemModel.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import Foundation

struct MovieTimeTabItemModel: Identifiable, Codable, Equatable {
  
    var id: String {
        self.area
    }
    let area: String
    let data: [MovieTimeResultModel]
}
