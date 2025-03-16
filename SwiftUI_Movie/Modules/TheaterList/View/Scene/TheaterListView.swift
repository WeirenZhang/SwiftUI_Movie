//
//  TheaterAreaView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import SwiftUI
import ComposableArchitecture

struct TheaterListView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<TheaterListFeature>
    @Bindable private var store: StoreOf<TheaterListFeature>
    private let theaterAreaModel: TheaterAreaModel
    
    init(
        store: StoreOf<TheaterListFeature>, theaterAreaModel: TheaterAreaModel
    ) {
        self.store = store
        self.theaterAreaModel = theaterAreaModel
    }
    
    var body: some View {
        
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(theaterAreaModel.theater_list) { item in
                        HStack {
                            Button {
                                navigateTotheaterTimeResult(theaterInfoModel: item)
                                //store.send(.detailButtonTapped(item))
                            } label: {
                                TheaterListCell(model: item)
                            }
                        }
                    }
                }
            }
            
            /*
             ErrorView(error: store.loadingState.failed ?? .unknown, action: store.send(.fetchGalleries))
             .opacity([.idle, .loading].contains(store.loadingState) ? 0 : 1)
             .zIndex(1)
             */
        }
        //.animation(.default, value: store.loadingState)
        ////.animation(.default, value: store.list)
        //.refreshable { store.send(.getTheaterList) }
        /*
         .onAppear {
         if store.list.isEmpty {
         DispatchQueue.main.async {
         
         store.send(.getTheaterList)
         }
         }
         }
         */
        .background(navigationLinks)
        .navigationTitle(theaterAreaModel.theater_top)
    }
}

// MARK: NavigationLinks
private extension TheaterListView {
    @ViewBuilder var navigationLinks: some View {
        theaterTimeResultViewLink
    }
    var theaterTimeResultViewLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.theaterTimeResult) { route in
            TheaterTimeResultView(
                //store: store.scope(state: \.theaterTimeResultState.wrappedValue!, action: \.theaterTimeResult),
                store: store.scope(state: \.theaterTimeResultState, action: \.theaterTimeResult),
                theaterInfoModel: route.wrappedValue
            )
        }
    }
    func navigateTotheaterTimeResult(theaterInfoModel: TheaterInfoModel) {
        
        store.send(.setNavigation(.theaterTimeResult(theaterInfoModel)))
    }
}

#Preview {
    //TheaterListView()
}
