//
//  SwiftUI_MovieApp.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/1/22.
//

import SwiftUI
import ComposableArchitecture
import GRDB

@main
struct SwiftUI_MovieApp: App {
    
    var body: some Scene {
        let _ = prepareDependencies {
            $0.defaultDatabase = try! DatabaseQueue.appDatabase()
        }
        WindowGroup {
            HomeView(store: Store(initialState: .init()) { HomeFeature() })
        }
    }
}


