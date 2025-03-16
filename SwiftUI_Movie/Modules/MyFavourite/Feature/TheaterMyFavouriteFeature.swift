//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture

@Reducer
struct TheaterMyFavouriteFeature {
    
    @CasePathable
    enum Route: Equatable {
        case theaterTimeResult(TheaterInfoModel)
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
        @SharedReader var theaters: TheaterCollection
        var theaterTimeResultState = TheaterTimeResultFeature.State()
        
        init() {
            let sort = Ordering.forward
            _theaters = SharedReader(
                .fetch(
                    AllTheatersQuery(ordering: sort.sortOrder),
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
        case deleteSwiped(Theater)
        //case getVideo(String)
        //case getVideoDone(Result<([VideoModel]), AppError>)
        case theaterTimeResult(TheaterTimeResultFeature.Action)
    }
    
    @Dependency(\.defaultDatabase) var database
    
    var body: some Reducer<State, Action> {
        
        BindingReducer()
            .onChange(of: \.route) { _, newValue in
                Reduce({ _, _ in newValue == nil ? .send(.clearSubStates) : .none })
            }
        
        Reduce
        { state, action in
            
            switch action {
            case .binding:
                
                return .none
                
            case .setNavigation(let route):
                state.route = route
                return route == nil ? .send(.clearSubStates) : .none
                
            case .clearSubStates:
                state.theaterTimeResultState = .init()
                return .merge(
                    .send(.theaterTimeResult(.teardown))
                )
                
            case .teardown:
                
                //return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                return .none
                
            case .deleteSwiped(let theater):
                _ = try? database.write { db in
                    try? theater.delete(db)
                }
                return .none
                
            case .theaterTimeResult:
                return .none
            }
        }
        Scope(state: \.theaterTimeResultState, action: \.theaterTimeResult, child: TheaterTimeResultFeature.init)
    }
}
