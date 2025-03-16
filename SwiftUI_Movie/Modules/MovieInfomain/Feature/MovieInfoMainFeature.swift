//
//  AppReducer.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 3/12/25.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MovieInfoMainFeature {
    @ObservableState
    struct State: Equatable {
        
        var tabBarState = MovieInfoMainTabBarReducer.State()
        var movieInfoState = MovieInfoFeature.State()
        var storeInfoState = StoreInfoFeature.State()
        var movieTimeTabsState = MovieTimeTabsFeature.State()
        //var movieTimeTabsState: Heap<MovieTimeTabsFeature.State?>
        var videoState = VideoFeature.State()
        var isfavorite = false
        
        init() {
            //movieTimeTabsState = .init(.init())
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case detailButtonTapped(TheaterInfoModel)
        case tabBar(MovieInfoMainTabBarReducer.Action)
        case teardown
        case check_favorite(MovieListModel)
        case favoriteTapped(MovieListModel)
        case movieInfo(MovieInfoFeature.Action)
        case storeInfo(StoreInfoFeature.Action)
        case movieTimeTabs(MovieTimeTabsFeature.Action)
        case video(VideoFeature.Action)
    }
    
    @Dependency(\.defaultDatabase) var database
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .tabBar(.setTabBarItemType(let type)):
                var effects = [Effect<Action>]()
                
                if type == state.tabBarState.tabBarItemType {
                    switch type {
                    case .movieInfo:
                        effects.append(.send(.movieInfo(.setNavigation(nil))))
                    case .storeInfo:
                        effects.append(.send(.storeInfo(.setNavigation(nil))))
                    case .movieTimeTabs:
                        effects.append(.send(.movieTimeTabs(.setNavigation(nil))))
                    case .video:
                        effects.append(.send(.video(.setNavigation(nil))))
                    }
                }
                return effects.isEmpty ? .none : .merge(effects)
                
            case .detailButtonTapped: return .none
                
            case .teardown:
                return .none
                
            case .tabBar:
                return .none
                
            case .check_favorite(let movieListModel):
                if (database.movie(movie_id: movieListModel.id) == nil) {
                    state.isfavorite = false
                } else {
                    state.isfavorite = true
                }
              
                return .none
                
            case .favoriteTapped(let movieListModel):
               
                if (state.isfavorite) {
                    let movie = try? database.write
                    {
                        try MovieQuery(movie_id: movieListModel.id).fetch($0)
                    }
                    let delete = try? database.write
                    {
                        try movie?.delete($0)
                    }
                    state.isfavorite = false
                    print(delete)
                } else {
                    let movie = try? database.write
                    {
                        try Movie.insert(in: $0, entry: movieListModel)
                    }
                    state.isfavorite = true
                    print(movie)
                }
              
                return .none
                
            case .movieInfo:
                return .none
                
            case .storeInfo:
                return .none
                
            case .movieTimeTabs:
                return .none
                
            case .video:
                return .none
            }
        }
        Scope(state: \.tabBarState, action: \.tabBar, child: MovieInfoMainTabBarReducer.init)
        Scope(state: \.movieInfoState, action: \.movieInfo, child: MovieInfoFeature.init)
        Scope(state: \.storeInfoState, action: \.storeInfo, child: StoreInfoFeature.init)
        Scope(state: \.movieTimeTabsState, action: \.movieTimeTabs, child: MovieTimeTabsFeature.init)
        Scope(state: \.videoState, action: \.video, child: VideoFeature.init)
    }
}
