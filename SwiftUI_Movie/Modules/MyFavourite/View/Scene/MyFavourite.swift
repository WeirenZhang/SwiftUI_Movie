//
//  MovieInfoMain.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import SwiftUI
import ComposableArchitecture
import SFSafeSymbols

struct MyFavourite: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<MovieInfoMainFeature>
    @Bindable private var store: StoreOf<MyFavouriteFeature>
    private let homeModel: HomeModel
    
    init(store: StoreOf<MyFavouriteFeature>, homeModel: HomeModel) {
        self.store = store
        self.homeModel = homeModel
    }
    
    var body: some View {
        
        ZStack {
            TabView(
                selection: .init(
                    get: { store.tabBarState.tabBarItemType },
                    set: { store.send(.tabBar(.setTabBarItemType($0))) }
                )
            ) {
                ForEach(MyFavouriteTabBarItemType.allCases) { type in
                    Group {
                        switch type {
                        case .movieMyFavourite:
                            MovieMyFavouriteView(
                                store: store.scope(state: \.movieMyFavouriteState, action: \.movieMyFavourite)
                            )
                        case .theaterMyFavourite:
                            TheaterMyFavouriteView(
                                store: store.scope(state: \.theaterMyFavouriteState, action: \.theaterMyFavourite)
                            )
                        }
                    }
                    .tabItem(type.label).tag(type)
                }
            }
        }
        .navigationTitle(homeModel.title)
        //.navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(.white, tintColor: .black)
    }
}

// MARK: TabType
enum MyFavouriteTabBarItemType: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    
    case movieMyFavourite
    case theaterMyFavourite
}

extension MyFavouriteTabBarItemType {
    var title: String {
        switch self {
        case .movieMyFavourite:
            return "電影"
        case .theaterMyFavourite:
            return "電影院"
        }
    }
    var symbol: SFSymbol {
        switch self {
        case .movieMyFavourite:
            return .movieclapper
        case .theaterMyFavourite:
            return .popcorn
        }
    }
    func label() -> Label<Text, Image> {
        Label(title, systemSymbol: symbol)
    }
}

#Preview {
    //MovieInfoMain(store: .init(initialState: .init(), reducer: MovieInfoMainFeature.init), movieListModel:  MovieListModel(title: "美國隊長：無畏新世界", en: "", release_movie_time: "", thumb:"",  id: "/movie/fcen14513804/"))
}


