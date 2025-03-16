//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture

@Reducer
struct ReuseWebViewFeature {
    @CasePathable
    enum Route: Equatable {
        
    }
    
    private enum CancelID: CaseIterable {
        
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        
        init() {
            
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case teardown
    }
    
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .binding:
                
                return .none
                
            case .teardown:
                
                //return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                return .none
            }
        }
    }
}
