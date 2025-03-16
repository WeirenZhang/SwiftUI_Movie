//
//  HomeFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/4.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct HomeFeature {
    @CasePathable
    enum Route: Equatable {
        case movieList(HomeModel)
        case theaterArea(HomeModel)
        case webView(VideoModel)
        case myFavourite(HomeModel)
        //case section(HomeSectionType)
    }
    
    @Reducer(state: .equatable)
    enum Path {
      case fromMovieList(MovieListFeature)
      case showMovieInfoMain(MovieInfoMainFeature)
      case showTheaterTimeResult(TheaterTimeResultFeature)
    }

    @ObservableState
    struct State: Equatable {
        var route: Route?
        var path = StackState<Path.State>()
        /*
        var cardPageIndex = 1
        var currentCardID = ""
        var allowsCardHitTesting = true
        var rawCardColors = [String: [Color]]()
        var cardColors: [Color] {
            rawCardColors[currentCardID] ?? [.clear]
        }

        var popularGalleries = [Gallery]()
        var popularLoadingState: LoadingState = .idle
        var frontpageGalleries = [Gallery]()
        var frontpageLoadingState: LoadingState = .idle
        var toplistsGalleries = [Int: [Gallery]]()
        var toplistsLoadingState = [Int: LoadingState]()
        */
        //var movieListState: Heap<MovieListFeature.State?>
        var movieListState = MovieListFeature.State()
        var theaterAreaState = TheaterAreaFeature.State()
        var myFavouriteState = MyFavouriteFeature.State()
        var reuseWebViewState = ReuseWebViewFeature.State()
        //var movieInfoMainState: Heap<MovieInfoMainFeature.State?>
        //var movieInfoMainState = MovieInfoMainFeature.State()
        /*
        var toplistsState = ToplistsReducer.State()
        var popularState = PopularReducer.State()
        var watchedState = WatchedReducer.State()
        var historyState = HistoryReducer.State()
        var detailState: Heap<DetailReducer.State?>
        */
        init() {
            //movieListState = .init(.init())
            //movieInfoMainState = .init(.init())
        }
        /*
        mutating func setPopularGalleries(_ galleries: [Gallery]) {
            let sortedGalleries = galleries.sorted { lhs, rhs in
                lhs.title.count > rhs.title.count
            }
            var trimmedGalleries = Array(sortedGalleries.prefix(min(sortedGalleries.count, 10)))
                .removeDuplicates(by: \.trimmedTitle)
            if trimmedGalleries.count >= 6 {
                trimmedGalleries = Array(trimmedGalleries.prefix(6))
            }
            trimmedGalleries.shuffle()
            popularGalleries = trimmedGalleries
            currentCardID = trimmedGalleries[cardPageIndex].gid
        }

        mutating func setFrontpageGalleries(_ galleries: [Gallery]) {
            frontpageGalleries = Array(galleries.prefix(min(galleries.count, 25)))
                .removeDuplicates(by: \.trimmedTitle)
        }
        */
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case setNavigation(Route?)
        
        case clearSubStates
        
        case path(StackActionOf<Path>)
        /*
        case setAllowsCardHitTesting(Bool)
        case analyzeImageColors(String, RetrieveImageResult)
        case analyzeImageColorsDone(String, UIImageColors?)

        case fetchAllGalleries
        case fetchAllToplistsGalleries
        case fetchPopularGalleries
        case fetchPopularGalleriesDone(Result<[Gallery], AppError>)
        case fetchFrontpageGalleries
        case fetchFrontpageGalleriesDone(Result<(PageNumber, [Gallery]), AppError>)
        case fetchToplistsGalleries(Int, Int? = nil)
        case fetchToplistsGalleriesDone(Int, Result<(PageNumber, [Gallery]), AppError>)
        */
        case movieList(MovieListFeature.Action)
        case theaterArea(TheaterAreaFeature.Action)
        case myFavourite(MyFavouriteFeature.Action)
        case webView(ReuseWebViewFeature.Action)
        //case movieInfoMain(MovieInfoMainFeature.Action)
        /*
        case popular(PopularReducer.Action)
        case watched(WatchedReducer.Action)
        case history(HistoryReducer.Action)
        case detail(DetailReducer.Action)
        */
    }

    //@Dependency(\.databaseClient) private var databaseClient
    //@Dependency(\.libraryClient) private var libraryClient

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
                
            case .path(let pathAction):
              return monitorPathChange(pathAction, state: &state)
            
            case .clearSubStates:
                state.movieListState = .init()
                state.theaterAreaState = .init()
                state.reuseWebViewState = .init()
                //state.movieInfoMainState.wrappedValue = .init()
                //state.movieInfoMainState = .init()
                state.myFavouriteState = .init()
                //state.historyState = .init()
                //state.detailState.wrappedValue = .init()
                return .merge(
                    .send(.movieList(.teardown)),
                    .send(.theaterArea(.teardown)),
                    .send(.webView(.teardown)),
                    .send(.myFavourite(.teardown))
                    //.send(.watched(.teardown)),
                    //.send(.detail(.teardown))
                )
            /*
            case .setAllowsCardHitTesting(let isAllowed):
                state.allowsCardHitTesting = isAllowed
                return .none

            case .fetchAllGalleries:
                return .merge(
                    .send(.fetchPopularGalleries),
                    .send(.fetchFrontpageGalleries),
                    .send(.fetchAllToplistsGalleries)
                )

            case .fetchAllToplistsGalleries:
                return .merge(
                    ToplistsType.allCases
                        .map { Action.fetchToplistsGalleries($0.categoryIndex) }
                        .map(Effect<Action>.send)
                )

            case .fetchPopularGalleries:
                guard state.popularLoadingState != .loading else { return .none }
                state.popularLoadingState = .loading
                state.rawCardColors = [String: [Color]]()
                let filter = databaseClient.fetchFilterSynchronously(range: .global)
                return .run { send in
                    let response = await PopularGalleriesRequest(filter: filter).response()
                    await send(.fetchPopularGalleriesDone(response))
                }

            case .fetchPopularGalleriesDone(let result):
                state.popularLoadingState = .idle
                switch result {
                case .success(let galleries):
                    guard !galleries.isEmpty else {
                        state.popularLoadingState = .failed(.notFound)
                        return .none
                    }
                    state.setPopularGalleries(galleries)
                    return .run(operation: { _ in await databaseClient.cacheGalleries(galleries) })
                case .failure(let error):
                    state.popularLoadingState = .failed(error)
                }
                return .none

            case .fetchFrontpageGalleries:
                guard state.frontpageLoadingState != .loading else { return .none }
                state.frontpageLoadingState = .loading
                let filter = databaseClient.fetchFilterSynchronously(range: .global)
                return .run { send in
                    let response = await FrontpageGalleriesRequest(filter: filter).response()
                    await send(.fetchFrontpageGalleriesDone(response))
                }

            case .fetchFrontpageGalleriesDone(let result):
                state.frontpageLoadingState = .idle
                switch result {
                case .success(let (_, galleries)):
                    guard !galleries.isEmpty else {
                        state.frontpageLoadingState = .failed(.notFound)
                        return .none
                    }
                    state.setFrontpageGalleries(galleries)
                    return .run(operation: { _ in await databaseClient.cacheGalleries(galleries) })
                case .failure(let error):
                    state.frontpageLoadingState = .failed(error)
                }
                return .none

            case .fetchToplistsGalleries(let index, let pageNum):
                guard state.toplistsLoadingState[index] != .loading else { return .none }
                state.toplistsLoadingState[index] = .loading
                return .run { send in
                    let response = await ToplistsGalleriesRequest(catIndex: index, pageNum: pageNum).response()
                    await send(.fetchToplistsGalleriesDone(index, response))
                }

            case .fetchToplistsGalleriesDone(let index, let result):
                state.toplistsLoadingState[index] = .idle
                switch result {
                case .success(let (_, galleries)):
                    guard !galleries.isEmpty else {
                        state.toplistsLoadingState[index] = .failed(.notFound)
                        return .none
                    }
                    state.toplistsGalleries[index] = galleries
                    return .run(operation: { _ in await databaseClient.cacheGalleries(galleries) })
                case .failure(let error):
                    state.toplistsLoadingState[index] = .failed(error)
                }
                return .none

            case .analyzeImageColors(let gid, let result):
                guard !state.rawCardColors.keys.contains(gid) else { return .none }
                return .run { send in
                    let colors = await libraryClient.analyzeImageColors(result.image)
                    await send(.analyzeImageColorsDone(gid, colors))
                }

            case .analyzeImageColorsDone(let gid, let colors):
                if let colors = colors {
                    state.rawCardColors[gid] = [
                        colors.primary, colors.secondary,
                        colors.detail, colors.background
                    ]
                    .map(Color.init)
                }
                return .none
            */
            case .movieList:
                return .none
            
            case .theaterArea:
                return .none
                
            case .myFavourite:
                return .none
                
            case .webView:
                return .none
            /*
            case .popular:
                return .none

            case .watched:
                return .none

            case .history:
                return .none

            case .detail:
                return .none
            */
            }
        }

        //Scope(state: \.movieListState, action: \.movieList, child: MovieListFeature.init)
        //Scope(state: \.toplistsState, action: \.toplists, child: ToplistsReducer.init)
        //Scope(state: \.popularState, action: \.popular, child: PopularReducer.init)
        //Scope(state: \.watchedState, action: \.watched, child: WatchedReducer.init)
        Scope(state: \.movieListState, action: \.movieList, child: MovieListFeature.init)
        Scope(state: \.theaterAreaState, action: \.theaterArea, child: TheaterAreaFeature.init)
        Scope(state: \.myFavouriteState, action: \.myFavourite, child: MyFavouriteFeature.init)
        //Scope(state: \.movieInfoMainState.wrappedValue!, action: \.movieInfoMain, child: MovieInfoMainFeature.init)
    }
}

extension HomeFeature {

  private func monitorPathChange(_ pathAction: StackActionOf<Path>, state: inout State) -> Effect<Action> {
    switch pathAction {

    //case .element(id: _, action: .showMovieInfoMain(.detailButtonTapped(let model))):
      //state.path.append(.showTheaterTimeResult(.init(model: model)))

    //case .element(id: _, action: .fromMovieList(.detailButtonTapped(let model))):
      //state.path.append(.showMovieInfoMain(.init(model: model)))

    default:
      break
    }
    return .none
  }
}
