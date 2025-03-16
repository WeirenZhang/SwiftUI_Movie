//
//  HomeView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/4.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    //@ComposableArchitecture.Bindable var store: StoreOf<HomeFeature>
    @Bindable var store: StoreOf<HomeFeature>
    let spacing: CGFloat = 10
    @State var numberOfColoun = 3
    
    let iteams = [
        HomeModel(icon: "enl_1", title: "本周新片", tab: "0"),
        HomeModel(icon: "enl_3", title: "本期首輪", tab: "1"),
        HomeModel(icon: "enl_3", title: "本期二輪", tab: "2"),
        HomeModel(icon: "enl_2", title: "近期上映", tab: "3"),
        HomeModel(icon: "enl_2", title: "新片快報", tab: "4"),
        HomeModel(icon: "enl_4", title: "電影院", tab: "5"),
        HomeModel(icon: "enl_5", title: "我的最愛", tab: "6"),
        HomeModel(icon: "enl_6", title: "網路訂票", tab: "7")
    ]
    
    var body: some View {
        
        let colunms = Array(repeating: GridItem(.flexible(),spacing: spacing), count: numberOfColoun)
        NavigationView {
            ScrollView {
                
                LazyVGrid(columns: colunms, spacing: spacing ) {
                    ForEach(iteams) { item in
                        Button(action: {
                            
                            switch Int(item.tab) {
                            case 0,1,2,3,4:
                                navigateToMovieList(model: item)
                            case 5:
                                navigateTotheaterArea(model: item)
                            case 6:
                                navigateTomyFavourite(model: item)
                            case 7:
                                navigateToreuseWebView(model: VideoModel(title: item.title, href: "https://www.ezding.com.tw/", cover: ""))
                            default:
                                "1"
                            }
                        }, label: {
                            HomeCell(model: item)
                        })
                    }
                }
                .offset(y: 180)
                .padding(.horizontal )
            }
            .background(navigationLinks)
            .background(Color.white)
            .ignoresSafeArea()
            .navigationTitle("電影時刻表")
            //.navigationBarColor(.white, tintColor: .black)
        }
    }
}

// MARK: NavigationLinks
private extension HomeView {
    @ViewBuilder var navigationLinks: some View {
        movieListViewLink
        theaterAreaViewLink
        myFavouriteLink
        reuseWebViewLink
    }
    var movieListViewLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.movieList) { route in
            MovieListView(
                store: store.scope(state: \.movieListState, action: \.movieList),
                homeModel: route.wrappedValue
            )
        }
    }
    var theaterAreaViewLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.theaterArea) { route in
            TheaterAreaView(
                store: store.scope(state: \.theaterAreaState, action: \.theaterArea),
                homeModel: route.wrappedValue
            )
        }
    }
    var myFavouriteLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.myFavourite) { route in
            MyFavourite(
                store: store.scope(state: \.myFavouriteState, action: \.myFavourite),
                homeModel: route.wrappedValue
            )
        }
    }
    var reuseWebViewLink: some View {
        NavigationLink(unwrapping: $store.route, case: \.webView) { route in
            ReuseWebView(
                store: store.scope(state: \.reuseWebViewState, action: \.webView),
                videoModel: route.wrappedValue
            )
        }
    }
    func navigateToMovieList(model: HomeModel) {
        
        store.send(.setNavigation(.movieList(model)))
    }
    func navigateTotheaterArea(model: HomeModel) {
        
        store.send(.setNavigation(.theaterArea(model)))
    }
    func navigateTomyFavourite(model: HomeModel) {
        
        store.send(.setNavigation(.myFavourite(model)))
    }
    func navigateToreuseWebView(model: VideoModel) {
        
        store.send(.setNavigation(.webView(model)))
    }
}

#Preview {
    HomeView(store: .init(initialState: .init(), reducer: HomeFeature.init))
}


