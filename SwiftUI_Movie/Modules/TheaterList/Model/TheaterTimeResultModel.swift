//
//  TheaterTimeResultModel.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

struct TheaterTimeResultModel: Identifiable, Codable, Equatable {
  
    let id: String
    let release_foto: String
    let theaterlist_name: String
    let length: String
    let icon: String
    let types: [TypesModel]
}
