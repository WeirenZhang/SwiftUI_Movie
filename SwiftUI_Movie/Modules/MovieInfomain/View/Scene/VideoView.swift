//
//  VideoView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import SwiftUI
import ComposableArchitecture

struct VideoView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<VideoFeature>
    @Bindable private var store: StoreOf<VideoFeature>
    private let movieListModel: MovieListModel
    
    init(
        store: StoreOf<VideoFeature>, movieListModel: MovieListModel
    ) {
        self.store = store
        self.movieListModel = movieListModel
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.list, id: \.self) { item in
                        HStack {
                            Button {
                                navigateToreuseWebView(model: item)
                            } label: {
                                VideoCell(model: item)
                            }
                        }
                    }
                }
            }
            .opacity(store.loadingState == .idle ? 1 : 0).zIndex(2)
            .background(navigationLinks)
            LoadingView()
                .opacity(store.loadingState == .loading ? 1 : 0).zIndex(0)
            
            let error = store.loadingState.failed
            ErrorView(error: error ?? .unknown) {
                store.send(.getVideo(movieListModel.id))
            }
            .opacity(store.list.isEmpty && error != nil ? 1 : 0)
            .zIndex(1)
        }
        .animation(.default, value: store.loadingState)
        .animation(.default, value: store.list)
        .refreshable { store.send(.getVideo(movieListModel.id)) }
        .onAppear {
            let error = store.loadingState.failed
            if store.list.isEmpty && error == nil {
                DispatchQueue.main.async {
                    
                    store.send(.getVideo(movieListModel.id))
                }
            }
        }
    }
}

// MARK: NavigationLinks
private extension VideoView {
    @ViewBuilder var navigationLinks: some View {
        reuseWebViewLink
    }
    var reuseWebViewLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.webView) { route in
            ReuseWebView(
                store: store.scope(state: \.reuseWebViewState, action: \.webView),
                videoModel: route.wrappedValue
            )
        }
    }
    func navigateToreuseWebView(model: VideoModel) {
        
        store.send(.setNavigation(.webView(model)))
    }
}


#Preview {
    VideoView(store: .init(initialState: .init(), reducer: VideoFeature.init), movieListModel:  MovieListModel(title:"",en:"",release_movie_time:"",thumb:"",id:"/movie/fsno14828040/"))
}
