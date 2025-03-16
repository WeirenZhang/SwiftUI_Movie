//
//  ReuseWebView.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/13.
//

import SwiftUI
import ComposableArchitecture

struct ReuseWebView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    //@ComposableArchitecture.Bindable var store: StoreOf<ReuseWebViewFeature>
    @Bindable private var store: StoreOf<ReuseWebViewFeature>
    private let videoModel: VideoModel
    @State private var isLoading: Bool = false
    @State private var progress: Double = 0.0
    
    init(
        store: StoreOf<ReuseWebViewFeature>, videoModel: VideoModel
    ) {
        self.store = store
        self.videoModel = videoModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0){
                
                HStack {
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16, alignment: .leading)
                    })
                    .frame(width: 40, height: 40, alignment: .leading)
                    Text(videoModel.title)
                        .font(.headline)
                        .lineLimit(1)
                        .frame(alignment: .leading)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .background(Color.white)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.vertical, 8)
                .background(Color.white)
                
                ZStack{
                    Divider()
                    if self.isLoading {
                        ProgressView(value: progress, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle())
                            .accentColor(.blue)
                            .scaleEffect(x: 1, y: 0.5, anchor: .trailing)
                    }
                }
                .frame(height: 4)
            }
            WebView(urlToDisplay: videoModel.href, isLoading: self.$isLoading, progress: self.$progress)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    //ReuseWebView()
}
