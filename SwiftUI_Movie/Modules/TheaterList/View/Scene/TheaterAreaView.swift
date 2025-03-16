//
//  TheaterAreaView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import SwiftUI
import ComposableArchitecture

struct TheaterAreaView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<TheaterAreaFeature>
    @Bindable private var store: StoreOf<TheaterAreaFeature>
    private let homeModel: HomeModel
    
    init(
        store: StoreOf<TheaterAreaFeature>, homeModel: HomeModel
    ) {
        self.store = store
        self.homeModel = homeModel
    }
    
    var body: some View {
        
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.list) { item in
                        HStack {
                            Button {
                                navigateTotheaterList(theaterAreaModel: item)
                            } label: {
                                Text(item.theater_top).bold().lineLimit(2).font(.system(size: 22)).padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
                                Spacer()
                            }
                        }
                    }
                }
            }
            .opacity(store.loadingState == .idle ? 1 : 0).zIndex(2)
            
            LoadingView()
                .opacity(store.loadingState == .loading ? 1 : 0).zIndex(0)
            
            /*
             ErrorView(error: store.loadingState.failed ?? .unknown, action: store.send(.fetchGalleries))
             .opacity([.idle, .loading].contains(store.loadingState) ? 0 : 1)
             .zIndex(1)
             */
        }
        .animation(.default, value: store.loadingState)
        .animation(.default, value: store.list)
        .refreshable { store.send(.getTheaterList) }
        .onAppear {
            if store.list.isEmpty {
                DispatchQueue.main.async {
                    
                    store.send(.getTheaterList)
                }
            }
        }
        .background(navigationLinks)
        .navigationTitle(homeModel.title)
    }
}

// MARK: NavigationLinks
private extension TheaterAreaView {
    @ViewBuilder var navigationLinks: some View {
        theaterListViewLink
    }
    var theaterListViewLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.theaterList) { route in
            TheaterListView(
                store: store.scope(state: \.theaterListState, action: \.theaterList),
                theaterAreaModel: route.wrappedValue
            )
        }
    }
    func navigateTotheaterList(theaterAreaModel: TheaterAreaModel) {
        
        store.send(.setNavigation(.theaterList(theaterAreaModel)))
    }
}

#Preview {
    //TheaterAreaView()
}
