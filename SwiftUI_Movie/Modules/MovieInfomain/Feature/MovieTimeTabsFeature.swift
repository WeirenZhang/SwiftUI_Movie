//
//  TheaterAreaFeature.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import ComposableArchitecture
import SwiftUICore
import SwiftUI

@Reducer
struct MovieTimeTabsFeature {
    
    @CasePathable
    enum Route: Equatable {
        case theaterTimeResult(TheaterInfoModel)
    }
    
    private enum CancelID: CaseIterable {
        case getMovieDateResult
    }
    
    @ObservableState
    struct State: Equatable {
        
        var route: Route?
        
        //var theaterTimeResultState: Heap<TheaterTimeResultFeature.State?>
        //var theaterTimeResultState = TheaterTimeResultFeature.State()
        var list = [MovieDateTabItemModel]()
        var loadingState: LoadingState = .idle
        var tabs = [Tab]()
        
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
        case getMovieDateResult(String)
        case getMovieDateResultDone(Result<([MovieDateTabItemModel]), AppError>)
        case changeTabs(Int)
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
                //state.theaterTimeResultState = .init()
                return .merge(
                    //.send(.theaterTimeResult(.teardown))
                )
                
            case .teardown:
                
                return .merge(CancelID.allCases.map(Effect.cancel(id:)))
                
            case .getMovieDateResult(let movie_id):
                
                guard state.loadingState != .loading else { return .none }
                state.loadingState = .loading
                return .run { send in
                    
                    let response = await GetMovieDateResultRequest(movie_id: movie_id).response()
                    print("response \(response)")
                    await send(.getMovieDateResultDone(response))
                }
                .cancellable(id: CancelID.getMovieDateResult)
                
            case .getMovieDateResultDone(let result):
                
                state.loadingState = .idle
                switch result {
                case .success(let (list)):
                    if list.isEmpty {
                        state.loadingState = .failed(.notFound)
                    } else if !list.isEmpty {
                        state.list = list
                        for item in list[0].list {
                            state.tabs.append(Tab(title: item.area))
                        }
                    }
                case .failure(let error):
                    state.loadingState = .failed(error)
                }
                return .none
                
            case .changeTabs(let index):
                state.tabs.removeAll()
                for item in state.list[index].list {
                    state.tabs.append(Tab(title: item.area))
                }
                return .none
                
            case .theaterTimeResult:
                return .none
            }
        }
        //Scope(state: \.theaterTimeResultState.wrappedValue!, action: \.theaterTimeResult, child: TheaterTimeResultFeature.init)
        //Scope(state: \.theaterTimeResultState, action: \.theaterTimeResult, child: TheaterTimeResultFeature.init)
    }
}
