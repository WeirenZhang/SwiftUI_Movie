//
//  MovieTimeResultModel.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import Foundation

struct MovieTimeResultModel: Identifiable, Codable, Equatable {
  
    let id: String
    let theater: String
    let types: [TypesModel]
}
