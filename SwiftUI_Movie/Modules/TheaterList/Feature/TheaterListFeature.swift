//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture

@Reducer
struct TheaterListFeature {
    @CasePathable
    enum Route: Equatable {
        case theaterTimeResult(TheaterInfoModel)
    }
    
    private enum CancelID: CaseIterable {
        
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        //var theaterTimeResultState: Heap<TheaterTimeResultFeature.State?>
        var theaterTimeResultState = TheaterTimeResultFeature.State()
        
        init() {
            //theaterTimeResultState = .init(.init())
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case setNavigation(Route?)
        case detailButtonTapped(TheaterInfoModel)
        case clearSubStates
        case teardown
        case theaterTimeResult(TheaterTimeResultFeature.Action)
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
                
                //state.theaterTimeResultState.wrappedValue = .init()
                state.theaterTimeResultState = .init()
                return .merge(
                    .send(.theaterTimeResult(.teardown))
                )
                
            case .teardown:
                
                //return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                return .none
                
            case .theaterTimeResult:
                return .none
            }
        }
        //Scope(state: \.theaterTimeResultState.wrappedValue!, action: \.theaterTimeResult, child: TheaterTimeResultFeature.init)
        Scope(state: \.theaterTimeResultState, action: \.theaterTimeResult, child: TheaterTimeResultFeature.init)
    }
}
