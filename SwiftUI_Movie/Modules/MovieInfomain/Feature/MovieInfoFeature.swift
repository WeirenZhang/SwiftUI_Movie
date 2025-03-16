//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture

@Reducer
struct MovieInfoFeature {
    
    @CasePathable
    enum Route: Equatable, Hashable {

    }
    
    private enum CancelID: CaseIterable {
        case getMovieInfo
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        var list = [MovieInfoModel]()
        var loadingState: LoadingState = .idle
        
        init() {
            
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case setNavigation(Route?)
        case clearSubStates
        case teardown
        case getMovieInfo(String)
        case getMovieInfoDone(Result<([MovieInfoModel]), AppError>)
    }
    
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            
            switch action {
            case .binding:
                
                return .none
                
            case .setNavigation(let route):
                state.route = route
                return route == nil ? .send(.clearSubStates) : .none
                
            case .clearSubStates:
                
                return .merge(

                )
                
            case .teardown:
                
                return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                
            case .getMovieInfo(let movie_id):
                
                guard state.loadingState != .loading else { return .none }
                state.loadingState = .loading
                return .run { send in
                    
                    let response = await GetMovieInfoRequest(movie_id: movie_id).response()
                    print("response \(response)")
                    await send(.getMovieInfoDone(response))
                }
                .cancellable(id: CancelID.getMovieInfo)
                
            case .getMovieInfoDone(let result):
                
                state.loadingState = .idle
                switch result {
                case .success(let (list)):
                    if list.isEmpty {
                        
                    } else if !list.isEmpty {
                        
                        state.list = list
                    }
                case .failure(let error):
                    state.loadingState = .failed(error)
                }
                return .none
            }
        }
    }
}
