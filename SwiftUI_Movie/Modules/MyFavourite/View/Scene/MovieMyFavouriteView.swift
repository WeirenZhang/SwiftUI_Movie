//
//  VideoView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import SwiftUI
import ComposableArchitecture

struct MovieMyFavouriteView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<VideoFeature>
    @Bindable private var store: StoreOf<MovieMyFavouriteFeature>
    
    init(
        store: StoreOf<MovieMyFavouriteFeature>
    ) {
        self.store = store
    }
    
    var body: some View {
        
        List(store.movies, id: \.id) { movie in
            HStack {
                Button {
                    navigateTomovieInfoMain(movieListModel: MovieListModel(title:movie.title,en:movie.en,release_movie_time:movie.release_movie_time,thumb:movie.thumb,id:movie.movie_id))
                } label: {
                    MovieListCell(model: MovieListModel(title:movie.title,en:movie.en,release_movie_time:movie.release_movie_time,thumb:movie.thumb,id:movie.movie_id))
                }
            }
            .swipeActions(allowsFullSwipe: false) {
                Utils.deleteMovieButton(movie) {
                    store.send(.deleteSwiped(movie), animation: .snappy)
                }
            }
        }
        .listStyle(.inset)
        .background(navigationLinks)
    }
}

// MARK: NavigationLinks
private extension MovieMyFavouriteView {
    @ViewBuilder var navigationLinks: some View {
        movieInfoMainLink
    }
    var movieInfoMainLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.movieInfoMain) { route in
            MovieInfoMain(
                //store: store.scope(state: \.movieInfoMainState.wrappedValue!, action: \.movieInfoMain),
                //movieListModel: route.wrappedValue
                store: store.scope(state: \.movieInfoMainState, action: \.movieInfoMain),
                movieListModel: route.wrappedValue
            )
        }
    }
    func navigateTomovieInfoMain(movieListModel: MovieListModel) {
        
        store.send(.setNavigation(.movieInfoMain(movieListModel)))
    }
}


#Preview {
    //VideoView()
}
