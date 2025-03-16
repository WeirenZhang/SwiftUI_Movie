//
//  TheaterAreaModel.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import Foundation

struct TheaterAreaModel: Identifiable, Codable, Equatable {
    
    var id: String {
        self.theater_top
    }
    let theater_top: String
    let theater_list: [TheaterInfoModel]
}
