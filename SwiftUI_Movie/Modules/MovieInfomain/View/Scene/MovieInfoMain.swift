//
//  MovieInfoMain.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import SwiftUI
import ComposableArchitecture
import SFSafeSymbols

struct MovieInfoMain: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<MovieInfoMainFeature>
    @Bindable private var store: StoreOf<MovieInfoMainFeature>
    private let movieListModel: MovieListModel
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(store: StoreOf<MovieInfoMainFeature>, movieListModel: MovieListModel) {
        self.store = store
        self.movieListModel = movieListModel
    }
    
    var body: some View {
        
        ZStack {
            TabView(
                selection: .init(
                    get: { store.tabBarState.tabBarItemType },
                    set: { store.send(.tabBar(.setTabBarItemType($0))) }
                )
            ) {
                ForEach(MovieInfoMainTabBarItemType.allCases) { type in
                    Group {
                        switch type {
                        case .movieInfo:
                            MovieInfoView(
                                store: store.scope(state: \.movieInfoState, action: \.movieInfo),
                                movieListModel: movieListModel
                            )
                        case .storeInfo:
                            StoreInfoView(
                                store: store.scope(state: \.storeInfoState, action: \.storeInfo),
                                movieListModel: movieListModel
                            )
                        case .movieTimeTabs:
                            MovieTimeTabsView(
                                //store: store.scope(state: \.movieTimeTabsState.wrappedValue!, action: \.movieTimeTabs),
                                store: store.scope(state: \.movieTimeTabsState, action: \.movieTimeTabs),
                                movieListModel: movieListModel
                            )
                        case .video:
                            VideoView(
                                store: store.scope(state: \.videoState, action: \.video),
                                movieListModel: movieListModel
                            )
                        }
                    }
                    .tabItem(type.label).tag(type)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                store.send(.check_favorite(movieListModel))
            }
        }
        .navigationTitle(movieListModel.title)
        //.navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(.white, tintColor: .black)
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                favoriteButton
            }
        }
    }
    
    private var favoriteButton: some View {
        Button {
            store.send(.favoriteTapped(movieListModel))
        } label: {
            if store.isfavorite {
                
                Image(systemName: "star.fill")
                    .accessibilityLabel("unfavorite movie")
                    .foregroundStyle(Utils.favoriteColor)
                //.transition(.confetti(color: Utils.favoriteColor, size: 3, enabled: store.animateButton))
                
            } else {
                Image(systemName: "star")
                    .accessibilityLabel("favorite movie")
            }
        }
    }
}

// MARK: TabType
enum MovieInfoMainTabBarItemType: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    
    case movieInfo
    case storeInfo
    case movieTimeTabs
    case video
}

extension MovieInfoMainTabBarItemType {
    var title: String {
        switch self {
        case .movieInfo:
            return "電影資料"
        case .storeInfo:
            return "劇情簡介"
        case .movieTimeTabs:
            return "播放時間"
        case .video:
            return "預告片"
        }
    }
    var symbol: SFSymbol {
        switch self {
        case .movieInfo:
            return .movieclapper
        case .storeInfo:
            return .doc
        case .movieTimeTabs:
            return .clock
        case .video:
            return .video
        }
    }
    func label() -> Label<Text, Image> {
        Label(title, systemSymbol: symbol)
    }
}

#Preview {
    //MovieInfoMain(store: .init(initialState: .init(), reducer: MovieInfoMainFeature.init), movieListModel:  MovieListModel(title: "美國隊長：無畏新世界", en: "", release_movie_time: "", thumb:"",  id: "/movie/fcen14513804/"))
}


