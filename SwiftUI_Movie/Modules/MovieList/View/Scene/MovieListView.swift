//
//  MovieListView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/1/31.
//

import SwiftUI
import ComposableArchitecture

struct MovieListView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<MovieListFeature>
    @Bindable private var store: StoreOf<MovieListFeature>
    private let homeModel: HomeModel
    
    private func shouldGetMoreMovieList(item: MovieListModel) -> Bool {
        
        let isLastGallery = item == store.list.last
        let isLoadingStateIdle = store.footerLoadingState == .idle
        let isLastPage = store.pageNumber.isLastPage
        return isLastGallery && isLoadingStateIdle && !isLastPage
    }
    
    private func shouldShowFooter(item: MovieListModel) -> Bool {
        
        let isLastGallery = item == store.list.last
        let isLoadingStateIdle = store.footerLoadingState == .idle
        return isLastGallery && !isLoadingStateIdle
    }
    
    private func shouldShowNoMoreFooter(item: MovieListModel) -> Bool {
        
        let isLastGallery = item == store.list.last
        let isLastPage = store.pageNumber.isLastPage
        return isLastGallery && isLastPage
    }
    
    init(
        store: StoreOf<MovieListFeature>, homeModel: HomeModel
    ) {
        self.store = store
        self.homeModel = homeModel
    }
    
    var body: some View {
        
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.list) { item in
                        HStack {
                            Button {
                                navigateTomovieInfoMain(movieListModel: item)
                                //store.send(.detailButtonTapped(item))
                            } label: {
                                MovieListCell(model: item)
                            }
                        }
                        .onAppear {
                            if shouldGetMoreMovieList(item: item) {
                                
                                store.send(.getMoreMovieList(homeModel.tab))
                            }
                        }
                        if shouldShowFooter(item: item) {
                            
                            FetchMoreFooter(loadingState: store.footerLoadingState, retryAction: {store.send(.getMoreMovieList(homeModel.tab))})
                        }
                        if shouldShowNoMoreFooter(item: item) {
                            
                            FetchNoMoreFooter()
                        }
                    }
                }
            }
            .opacity(store.loadingState == .idle ? 1 : 0).zIndex(2)
            
            LoadingView()
                .opacity(store.loadingState == .loading ? 1 : 0).zIndex(0)
            
            let error = store.loadingState.failed
            ErrorView(error: error ?? .unknown) {
                store.send(.getMovieList(homeModel.tab))
            }
            .opacity(store.list.isEmpty && error != nil ? 1 : 0)
            .zIndex(1)
        }
        .animation(.default, value: store.loadingState)
        .animation(.default, value: store.list)
        .refreshable { store.send(.getMovieList(homeModel.tab)) }
        .onAppear {
            if store.list.isEmpty {
                DispatchQueue.main.async {
                    
                    store.send(.getMovieList(homeModel.tab))
                }
            }
        }
        .background(navigationLinks)
        .navigationTitle(homeModel.title)
    }
}

// MARK: NavigationLinks
private extension MovieListView {
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
    //MovieListView(store: .init(initialState: .init(), reducer: MovieListFeature.init))
}
