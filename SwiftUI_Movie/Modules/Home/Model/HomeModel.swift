//
//  HomeModel.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/4.
//

import Foundation

struct HomeModel: Identifiable, Equatable {
    
    let id = UUID()
    let icon: String
    let title: String
    let tab: String
}
