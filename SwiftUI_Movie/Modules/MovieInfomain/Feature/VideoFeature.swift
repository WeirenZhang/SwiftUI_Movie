//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture

@Reducer
struct VideoFeature {
    
    @CasePathable
    enum Route: Equatable {
        case webView(VideoModel)
    }
    
    private enum CancelID: CaseIterable {
        case getVideo
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        var list = [VideoModel]()
        var loadingState: LoadingState = .idle
        var reuseWebViewState = ReuseWebViewFeature.State()
        
        init() {
            
        }
    }
    
    indirect enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        case setNavigation(Route?)
        case clearSubStates
        case teardown
        case getVideo(String)
        case getVideoDone(Result<([VideoModel]), AppError>)
        case webView(ReuseWebViewFeature.Action)
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
                state.reuseWebViewState = .init()
                return .merge(
                    .send(.webView(.teardown))
                )
                
            case .teardown:
                
                return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                
            case .getVideo(let movie_id):
                
                guard state.loadingState != .loading else { return .none }
                state.loadingState = .loading
                return .run { send in
                    
                    let response = await GetVideoRequest(movie_id: movie_id).response()
                    print("response \(response)")
                    await send(.getVideoDone(response))
                }
                .cancellable(id: CancelID.getVideo)
                
            case .getVideoDone(let result):
                
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
                
            case .webView:
                return .none
            }
        }
    }
}
