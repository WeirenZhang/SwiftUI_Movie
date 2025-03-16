//
//  TabBarReducer.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/12/29.
//

import ComposableArchitecture

@Reducer
struct MovieInfoMainTabBarReducer {
    @ObservableState
    struct State: Equatable {
        var tabBarItemType: MovieInfoMainTabBarItemType = .movieInfo
    }
    
    enum Action: Equatable {
        case setTabBarItemType(MovieInfoMainTabBarItemType)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setTabBarItemType(let type):
                state.tabBarItemType = type
                return .none
            }
        }
    }
}
