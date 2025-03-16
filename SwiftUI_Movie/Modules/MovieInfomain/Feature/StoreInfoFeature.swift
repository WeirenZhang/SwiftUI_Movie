//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture

@Reducer
struct StoreInfoFeature {
    
    @CasePathable
    enum Route: Equatable, Hashable {

    }
    
    private enum CancelID: CaseIterable {
        case getStoreInfo
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        var list = [StoreInfoModel]()
        var loadingState: LoadingState = .idle
        
        init() {
            
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case setNavigation(Route?)
        case clearSubStates
        case teardown
        case getStoreInfo(String)
        case getStoreInfoDone(Result<([StoreInfoModel]), AppError>)
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
                
            case .getStoreInfo(let movie_id):
                
                guard state.loadingState != .loading else { return .none }
                state.loadingState = .loading
                return .run { send in
                    
                    let response = await GetStoreInfoRequest(movie_id: movie_id).response()
                    print("response \(response)")
                    await send(.getStoreInfoDone(response))
                }
                .cancellable(id: CancelID.getStoreInfo)
                
            case .getStoreInfoDone(let result):
                
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
