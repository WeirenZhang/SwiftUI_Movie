//
//  TheaterTimeResultView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/12.
//

import SwiftUI
import ComposableArchitecture

struct TheaterTimeResultView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<TheaterTimeResultFeature>
    @Bindable private var store: StoreOf<TheaterTimeResultFeature>
    private let theaterInfoModel: TheaterInfoModel
    @State var index = 0
    
    init(
        store: StoreOf<TheaterTimeResultFeature>, theaterInfoModel: TheaterInfoModel
    ) {
        self.store = store
        self.theaterInfoModel = theaterInfoModel
    }
    
    var dropdownItems: [DropdownItem] {
        
        var result: Array<DropdownItem> = []
        for (index, item) in store.list.enumerated() {
            print(item)
            result.append(DropdownItem(id: index, title: item.date, onSelect: {
                self.index = index
            }))
        }
        return result
    }
    
    var body: some View {
        
        ZStack {
            ZStack {
                if (store.list.count > 0) {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(store.list[index].data) { item in
                                HStack {
                                    
                                    Button {
                                        navigateTomovieInfoMain(movieListModel: MovieListModel(title:item.theaterlist_name,en:"",release_movie_time:"",thumb:item.release_foto,id:item.id))
                                    } label: {
                                        TheaterTimeResultCell(model: item)
                                    }
                                }
                            }
                        }
                    }
                    .customDropdownMenu(items: dropdownItems)
                }
            }
            .opacity(store.loadingState == .idle ? 1 : 0).zIndex(2)
            
            LoadingView()
                .opacity(store.loadingState == .loading ? 1 : 0).zIndex(0)
            
            let error = store.loadingState.failed
            ErrorView(error: error ?? .unknown) {
                store.send(.getTheaterResultList(theaterInfoModel.id))
            }
            .opacity(store.list.isEmpty && error != nil ? 1 : 0)
            .zIndex(1)
        }
        .animation(.default, value: store.loadingState)
        .animation(.default, value: store.list)
        .refreshable { store.send(.getTheaterResultList(theaterInfoModel.id)) }
        .onAppear {
            if store.list.isEmpty {
                DispatchQueue.main.async {
                    store.send(.check_favorite(theaterInfoModel))
                    store.send(.getTheaterResultList(theaterInfoModel.id))
                }
            }
        }
        .background(navigationLinks)
        .navigationTitle(theaterInfoModel.name)
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                favoriteButton
            }
        }
    }
    
    private var favoriteButton: some View {
        Button {
            store.send(.favoriteTapped(theaterInfoModel))
        } label: {
            if store.isfavorite {
                
                Image(systemName: "star.fill")
                    .accessibilityLabel("unfavorite theater")
                    .foregroundStyle(Utils.favoriteColor)
                //.transition(.confetti(color: Utils.favoriteColor, size: 3, enabled: store.animateButton))
                
            } else {
                Image(systemName: "star")
                    .accessibilityLabel("favorite theater")
            }
        }
    }
}

// MARK: NavigationLinks
private extension TheaterTimeResultView {
    @ViewBuilder var navigationLinks: some View {
        movieInfoMainLink
    }
    var movieInfoMainLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.movieInfoMain) { route in
            MovieInfoMain(
                //store: store.scope(state: \.movieInfoMainState.wrappedValue!, action: \.movieInfoMain),
                //movieListModel: route.wrappedValue
                store: store.scope(state: \.movieInfoMainState, action: \.movieInfoMain),
                movieListModel: route.wrappedValue
            )
        }
    }
    func navigateTomovieInfoMain(movieListModel: MovieListModel) {
        
        store.send(.setNavigation(.movieInfoMain(movieListModel)))
    }
}

#Preview {
    //TheaterTimeResultView()
}
