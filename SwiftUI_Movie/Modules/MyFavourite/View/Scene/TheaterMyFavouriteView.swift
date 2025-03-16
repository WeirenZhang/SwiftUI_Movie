//
//  VideoView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/14.
//

import SwiftUI
import ComposableArchitecture

struct TheaterMyFavouriteView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<VideoFeature>
    @Bindable private var store: StoreOf<TheaterMyFavouriteFeature>
    
    init(
        store: StoreOf<TheaterMyFavouriteFeature>
    ) {
        self.store = store
    }
    
    var body: some View {
        
        List(store.theaters, id: \.id) { theater in
            HStack {
                Button {
                    navigateTotheaterTimeResult(theaterInfoModel: TheaterInfoModel(id:theater.theater_id,name:theater.name,adds:theater.adds,tel:theater.tel))
                } label: {
                    TheaterListCell(model: TheaterInfoModel(id:theater.theater_id,name:theater.name,adds:theater.adds,tel:theater.tel))
                }
            }
            .swipeActions(allowsFullSwipe: false) {
                Utils.deleteTheaterButton(theater) {
                    store.send(.deleteSwiped(theater), animation: .snappy)
                }
            }
        }
        .listStyle(.inset)
        .background(navigationLinks)
    }
}

// MARK: NavigationLinks
private extension TheaterMyFavouriteView {
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
    //VideoView()
}
