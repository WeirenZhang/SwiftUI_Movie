//
//  MovieTimeTabsView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import SwiftUI
import ComposableArchitecture

struct MovieTimeTabsView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<MovieTimeTabsFeature>
    @Bindable private var store: StoreOf<MovieTimeTabsFeature>
    private let movieListModel: MovieListModel
    @State var index = 0
    @State private var selectedTab: Int = 0
    
    init(
        store: StoreOf<MovieTimeTabsFeature>, movieListModel: MovieListModel
    ) {
        self.store = store
        self.movieListModel = movieListModel
    }
    
    var dropdownItems: [DropdownItem] {
        
        var result: Array<DropdownItem> = []
        for (index, item) in store.list.enumerated() {
            print(item)
            result.append(DropdownItem(id: index, title: item.date, onSelect: {
                self.index = index
                store.send(.changeTabs(index))
            }))
        }
        return result
    }
    
    var body: some View {
        ZStack {
            ZStack {
                if (store.list.count > 0) {
                    GeometryReader { geo in
                        VStack {
                            Tabs(tabs: store.tabs, geoWidth: geo.size.width, selectedTab: $selectedTab)
                            TabView(selection: $selectedTab) {
                                ForEach(Array(store.tabs.enumerated()), id: \.offset) { offset, tab in
                                    ScrollView {
                                        LazyVStack(spacing: 0) {
                                            ForEach(store.list[index].list[offset].data) { item in
                                                HStack {
                                                    Button {
                                                        store.send(.detailButtonTapped(TheaterInfoModel(id:item.id,name:item.theater,adds:"",tel:"")))
                                                        //navigateTotheaterTimeResult(theaterInfoModel: TheaterInfoModel(id:item.id,name:item.theater,adds:"",tel:""))
                                                    } label: {
                                                        MovieTimeResultCell(model: item)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                        }
                        .customDropdownMenu(items: dropdownItems)
                    }
                }
            }
            .opacity(store.loadingState == .idle ? 1 : 0).zIndex(2)
            LoadingView()
                .opacity(store.loadingState == .loading ? 1 : 0).zIndex(0)
            
            let error = store.loadingState.failed
            ErrorView(error: error ?? .unknown) {
                store.send(.getMovieDateResult(movieListModel.id))
            }
            .opacity(store.list.isEmpty && error != nil ? 1 : 0)
            .zIndex(1)
        }
        //.background(navigationLinks)
        .animation(.default, value: store.loadingState)
        .animation(.default, value: store.list)
        .refreshable { store.send(.getMovieDateResult(movieListModel.id)) }
        .onAppear {
            let error = store.loadingState.failed
            if store.list.isEmpty && error == nil {
                DispatchQueue.main.async {
                    
                    store.send(.getMovieDateResult(movieListModel.id))
                }
            }
        }
    }
}

// MARK: NavigationLinks
private extension MovieTimeTabsView {
    @ViewBuilder var navigationLinks: some View {
        theaterTimeResultViewLink
    }
    var theaterTimeResultViewLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.theaterTimeResult) { route in
            //TheaterTimeResultView(
            //store: store.scope(state: \.theaterTimeResultState.wrappedValue!, action: \.theaterTimeResult),
            //store: store.scope(state: \.theaterTimeResultState, action: \.theaterTimeResult),
            //theaterInfoModel: route.wrappedValue
            //)
        }
    }
    func navigateTotheaterTimeResult(theaterInfoModel: TheaterInfoModel) {
        
        store.send(.setNavigation(.theaterTimeResult(theaterInfoModel)))
    }
}

#Preview {
    MovieTimeTabsView(store: .init(initialState: .init(), reducer: MovieTimeTabsFeature.init), movieListModel:  MovieListModel(title: "美國隊長：無畏新世界", en: "", release_movie_time: "", thumb:"",  id: "/movie/fljp32485961/"))
}
