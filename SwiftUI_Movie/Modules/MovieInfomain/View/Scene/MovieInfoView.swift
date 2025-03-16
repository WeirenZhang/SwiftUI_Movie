//
//  MovieInfoView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import SwiftUI
import ComposableArchitecture

struct MovieInfoView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<MovieInfoFeature>
    @Bindable private var store: StoreOf<MovieInfoFeature>
    private let movieListModel: MovieListModel
    
    init(
        store: StoreOf<MovieInfoFeature>, movieListModel: MovieListModel
    ) {
        self.store = store
        self.movieListModel = movieListModel
    }
    
    var body: some View {
        ZStack {
            
            ForEach(store.list, id: \.self) { item in
                MovieInfoCell(model: item)
            }
            .opacity(store.loadingState == .idle ? 1 : 0).zIndex(2)
            LoadingView()
                .opacity(store.loadingState == .loading ? 1 : 0).zIndex(0)
            /*
             ErrorView(error: store.loadingState.failed ?? .unknown, action: store.send(.fetchGalleries))
             .opacity([.idle, .loading].contains(store.loadingState) ? 0 : 1)
             .zIndex(1)
             */
        }
        .animation(.default, value: store.loadingState)
        .animation(.default, value: store.list)
        .refreshable { store.send(.getMovieInfo(movieListModel.id)) }
        .onAppear {
            let error = store.loadingState.failed
            if store.list.isEmpty && error == nil {
                DispatchQueue.main.async {
                    
                    store.send(.getMovieInfo(movieListModel.id))
                }
            }
        }
    }
}

#Preview {
    MovieInfoView(store: .init(initialState: .init(), reducer: MovieInfoFeature.init), movieListModel:  MovieListModel(title:"米奇17號",en:"",release_movie_time:"",thumb:"",id:"/movie/fmen12299608/"))
}
