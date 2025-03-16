//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture

@Reducer
struct TheaterAreaFeature {
    @CasePathable
    enum Route: Equatable {
        case theaterList(TheaterAreaModel)
    }
    
    private enum CancelID: CaseIterable {
        case getTheaterList
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        var list = [TheaterAreaModel]()
        var loadingState: LoadingState = .idle
        var theaterListState = TheaterListFeature.State()
        
        init() {
            
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case setNavigation(Route?)
        case clearSubStates
        case teardown
        case getTheaterList
        case getTheaterListDone(Result<([TheaterAreaModel]), AppError>)
        case theaterList(TheaterListFeature.Action)
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
                
            case .setNavigation(let route):
                
                state.route = route
                return route == nil ? .send(.clearSubStates) : .none
                
            case .clearSubStates:
                
                state.theaterListState = .init()
                return .merge(
                    .send(.theaterList(.teardown))
                )
                
            case .teardown:
                
                return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                
            case .getTheaterList:
                
                guard state.loadingState != .loading else { return .none }
                state.loadingState = .loading
                return .run { send in
                    
                    let response = await GetTheaterListRequest().response()
                    print("response \(response)")
                    await send(.getTheaterListDone(response))
                }
                .cancellable(id: CancelID.getTheaterList)
                
            case .getTheaterListDone(let result):
                
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
            case .theaterList:
                return .none
            }
        }
        Scope(state: \.theaterListState, action: \.theaterList, child: TheaterListFeature.init)
    }
}
