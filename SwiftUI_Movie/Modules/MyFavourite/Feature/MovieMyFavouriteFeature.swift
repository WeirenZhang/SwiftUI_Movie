//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture
import Sharing

@Reducer
struct MovieMyFavouriteFeature {
    
    @CasePathable
    enum Route: Equatable {
        case movieInfoMain(MovieListModel)
    }
    
    private enum CancelID: CaseIterable {
        //case getVideo
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        //var list = [VideoModel]()
        //var loadingState: LoadingState = .idle
        //var reuseWebViewState = ReuseWebViewFeature.State()
        @SharedReader var movies: MovieCollection
        var movieInfoMainState = MovieInfoMainFeature.State()
        
        init() {
            let sort = Ordering.forward
            _movies = SharedReader(
                .fetch(
                    AllMoviesQuery(ordering: sort.sortOrder),
                    animation: .smooth
                )
            )
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case setNavigation(Route?)
        case clearSubStates
        case teardown
        case deleteSwiped(Movie)
        //case getVideo(String)
        //case getVideoDone(Result<([VideoModel]), AppError>)
        //case webView(ReuseWebViewFeature.Action)
        case movieInfoMain(MovieInfoMainFeature.Action)
    }
    
    @Dependency(\.defaultDatabase) var database
    
    var body: some Reducer<State, Action> {
        
        BindingReducer()
            .onChange(of: \.route) { _, newValue in
                Reduce({ _, _ in newValue == nil ? .send(.clearSubStates) : .none })
            }
        
        Reduce { state, action in
            
            switch action {
            case .binding:
                
                return .none
                
            case .setNavigation(let route):
                state.route = route
                return route == nil ? .send(.clearSubStates) : .none
                
            case .clearSubStates:
                //state.reuseWebViewState = .init()
                state.movieInfoMainState = .init()
                return .merge(
                    .send(.movieInfoMain(.teardown))
                )
                
            case .teardown:
                
                //return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                return .none
                
            case .deleteSwiped(let movie):
                _ = try? database.write { db in
                    try? movie.delete(db)
                }
                return .none
                
            case .movieInfoMain:
                return .none
            }
        }
        Scope(state: \.movieInfoMainState, action: \.movieInfoMain, child: MovieInfoMainFeature.init)
    }
}
