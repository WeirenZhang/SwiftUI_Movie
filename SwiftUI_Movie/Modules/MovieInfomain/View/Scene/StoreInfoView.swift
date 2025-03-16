//
//  StoreInfoView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import SwiftUI
import ComposableArchitecture

struct StoreInfoView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<StoreInfoFeature>
    @Bindable private var store: StoreOf<StoreInfoFeature>
    private let movieListModel: MovieListModel
    
    init(
        store: StoreOf<StoreInfoFeature>, movieListModel: MovieListModel
    ) {
        self.store = store
        self.movieListModel = movieListModel
    }
    
    var body: some View {
        
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.list, id: \.self) { item in
                        HStack {
                            Text(item.storeInfo).foregroundColor(.secondary).bold().lineLimit(nil).font(.system(size: 24)).padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                            Spacer()
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
        .refreshable { store.send(.getStoreInfo(movieListModel.id)) }
        .onAppear {
            if store.list.isEmpty {
                DispatchQueue.main.async {
                    
                    store.send(.getStoreInfo(movieListModel.id))
                }
            }
        }
    }
}

#Preview {
    //StoreInfoView()
}
