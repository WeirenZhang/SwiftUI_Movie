//
//  TabBarReducer.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/12/29.
//

import ComposableArchitecture

@Reducer
struct MyFavouriteTabBarReducer {
    @ObservableState
    struct State: Equatable {
        var tabBarItemType: MyFavouriteTabBarItemType = .movieMyFavourite
    }
    
    enum Action: Equatable {
        case setTabBarItemType(MyFavouriteTabBarItemType)
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
