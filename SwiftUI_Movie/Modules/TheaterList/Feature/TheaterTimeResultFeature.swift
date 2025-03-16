//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture

@Reducer
struct TheaterTimeResultFeature: Reducer {
    @CasePathable
    enum Route: Equatable {
        case movieInfoMain(MovieListModel)
    }
    
    private enum CancelID: CaseIterable {
        case getTheaterResultList
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        var list = [TheaterDateItemModel]()
        var loadingState: LoadingState = .idle
        //var movieInfoMainState: Heap<MovieInfoMainFeature.State?>
        var movieInfoMainState = MovieInfoMainFeature.State()
        var isfavorite = false
        
        init() {
            //movieInfoMainState = .init(.init())
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case detailButtonTapped(TheaterInfoModel)
        case setNavigation(Route?)
        case clearSubStates
        case teardown
        case check_favorite(TheaterInfoModel)
        case favoriteTapped(TheaterInfoModel)
        case getTheaterResultList(String)
        case getTheaterResultListDone(Result<([TheaterDateItemModel]), AppError>)
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
                
            case .check_favorite(let theaterInfoModel):
                
                if (database.theater(theater_id: theaterInfoModel.id) == nil) {
                    state.isfavorite = false
                } else {
                    state.isfavorite = true
                }
              
                return .none
                
            case .favoriteTapped(let theaterInfoModel):
               
                if (state.isfavorite) {
                    
                    let theater = try? database.write
                    {
                        try TheaterQuery(theater_id: theaterInfoModel.id).fetch($0)
                    }
                    
                    let delete = try? database.write
                    {
                        try theater?.delete($0)
                    }
                    state.isfavorite = false
                    print(delete)
                     
                } else {
                    
                    let theater = try? database.write
                    {
                        try Theater.insert(in: $0, entry: theaterInfoModel)
                    }
                    state.isfavorite = true
                    print(theater)
                    
                }
              
                return .none
                
            case .getTheaterResultList(let cinema_id):
                
                guard state.loadingState != .loading else { return .none }
                state.loadingState = .loading
                return .run { send in
                    
                    let response = await GetTheaterResultListRequest(cinema_id: cinema_id).response()
                    print("response \(response)")
                    await send(.getTheaterResultListDone(response))
                }
                .cancellable(id: CancelID.getTheaterResultList)
                
            case .getTheaterResultListDone(let result):
                
                state.loadingState = .idle
                switch result {
                case .success(let (list)):
                    if list.isEmpty {
                        state.loadingState = .failed(.notFound)
                    } else if !list.isEmpty {
                        
                        state.list = list
                    }
                case .failure(let error):
                    state.loadingState = .failed(error)
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
