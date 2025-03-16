//
//  AppReducer.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/12/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MyFavouriteFeature {
    @ObservableState
    struct State: Equatable {
        
        var tabBarState = MyFavouriteTabBarReducer.State()
        var movieMyFavouriteState = MovieMyFavouriteFeature.State()
        var theaterMyFavouriteState = TheaterMyFavouriteFeature.State()
        //var movieTimeTabsState: Heap<MovieTimeTabsFeature.State?>
        
        init() {
            //movieTimeTabsState = .init(.init())
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tabBar(MyFavouriteTabBarReducer.Action)
        case teardown
        case movieMyFavourite(MovieMyFavouriteFeature.Action)
        case theaterMyFavourite(TheaterMyFavouriteFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .tabBar(.setTabBarItemType(let type)):
                var effects = [Effect<Action>]()
                
                if type == state.tabBarState.tabBarItemType {
                    switch type {
                    case .movieMyFavourite:
                        effects.append(.send(.movieMyFavourite(.setNavigation(nil))))
                    case .theaterMyFavourite:
                        effects.append(.send(.theaterMyFavourite(.setNavigation(nil))))
                    }
                }
                return effects.isEmpty ? .none : .merge(effects)
                
            case .teardown:
                return .none
                
            case .tabBar:
                return .none
                
            case .movieMyFavourite:
                return .none
                
            case .theaterMyFavourite:
                return .none
            }
        }
        Scope(state: \.tabBarState, action: \.tabBar, child: MyFavouriteTabBarReducer.init)
        Scope(state: \.movieMyFavouriteState, action: \.movieMyFavourite, child: MovieMyFavouriteFeature.init)
        Scope(state: \.theaterMyFavouriteState, action: \.theaterMyFavourite, child: TheaterMyFavouriteFeature.init)
    }
    
}
