//
//  TheaterDateItemModel.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

struct TheaterDateItemModel: Identifiable, Codable, Equatable {
    
    var id: String {
        self.date
    }
    let date: String
    let data: [TheaterTimeResultModel]
}
