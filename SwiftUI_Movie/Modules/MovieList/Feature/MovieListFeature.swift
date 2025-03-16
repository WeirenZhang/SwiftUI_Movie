//
//  MovieListFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/1/31.
//

import ComposableArchitecture

@Reducer
struct MovieListFeature {
    @CasePathable
    enum Route: Equatable {
        case movieInfoMain(MovieListModel)
    }
    
    private enum CancelID: CaseIterable {
        case getMovieList, getMoreMovieList
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        var list = [MovieListModel]()
        var pageNumber = PageNumber()
        var loadingState: LoadingState = .idle
        var footerLoadingState: LoadingState = .idle
        //var movieInfoMainState: Heap<MovieInfoMainFeature.State?>
        var movieInfoMainState = MovieInfoMainFeature.State()
        
        init() {
            //movieInfoMainState = .init(.init())
        }
        
        mutating func insertGalleries(_ list: [MovieListModel]) {
            list.forEach { item in
                if !self.list.contains(item) {
                    self.list.append(item)
                }
            }
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case detailButtonTapped(MovieListModel)
        case setNavigation(Route?)
        case teardown
        case clearSubStates
        case getMovieList(String)
        case getMovieListDone(Result<([MovieListModel]), AppError>)
        case getMoreMovieList(String)
        case getMoreMovieListDone(Result<([MovieListModel]), AppError>)
        case movieInfoMain(MovieInfoMainFeature.Action)
    }
    
    
    var body: some Reducer<State, Action> {
        
        BindingReducer()
            .onChange(of: \.route) { _, newValue in
                Reduce({ _, _ in newValue == nil ? .send(.clearSubStates) : .none })
            }
        
        Reduce { state, action in
            switch action {
            case .binding:
                
                return .none
                
            case .detailButtonTapped: return .none
                
            case .setNavigation(let route):
                
                state.route = route
                return route == nil ? .send(.clearSubStates) : .none
                
            case .clearSubStates:
                
                //state.movieInfoMainState.wrappedValue = .init()
                state.movieInfoMainState = .init()
                return .merge(
                    .send(.movieInfoMain(.teardown))
                )
                
            case .teardown:
                
                return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                
            case .getMovieList(let tab):
                
                guard state.loadingState != .loading else { return .none }
                state.loadingState = .loading
                state.pageNumber.resetPages()
                let page = state.pageNumber.current
                return .run { send in
                    
                    let response = await GetMovieListRequest(tab: tab, page: page).response()
                    print("response \(response)")
                    await send(.getMovieListDone(response))
                }
                .cancellable(id: CancelID.getMovieList)
                
            case .getMovieListDone(let result):
                
                state.loadingState = .idle
                switch result {
                case .success(let (list)):
                    if list.isEmpty {
                        state.loadingState = .failed(.notFound)
                    } else if !list.isEmpty {
                        
                        state.pageNumber.current += 1
                        state.list = list
                    }
                case .failure(let error):
                    state.loadingState = .failed(error)
                }
                return .none
                
            case .getMoreMovieList(let tab):
                
                print("getMoreMovieList")
                state.footerLoadingState = .loading
                let page = state.pageNumber.current
                return .run { send in
                    let response = await GetMovieListRequest(tab: tab, page: page).response()
                    print("response \(response)")
                    await send(.getMoreMovieListDone(response))
                }
                .cancellable(id: CancelID.getMoreMovieList)
                
            case .getMoreMovieListDone(let result):
                
                state.footerLoadingState = .idle
                switch result {
                case .success(let (list)):
                    if list.isEmpty {
                        state.pageNumber.isLastPage = true
                    } else if !list.isEmpty {
                        state.loadingState = .idle
                        state.pageNumber.current += 1
                        state.insertGalleries(list)
                    }
                    return .none
                case .failure(let error):
                    state.footerLoadingState = .failed(error)
                }
                return .none
            case .movieInfoMain:
                return .none
            }
        }
        //Scope(state: \.movieInfoMainState.wrappedValue!, action: \.movieInfoMain, child: MovieInfoMainFeature.init)
        Scope(state: \.movieInfoMainState, action: \.movieInfoMain, child: MovieInfoMainFeature.init)
    }
}

