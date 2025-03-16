//
//  VideoCell.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/3/9.
//

import SwiftUI
import Kingfisher

struct VideoCell: View {
    
    private let model: VideoModel
    
    init(model: VideoModel) {
        self.model = model
    }
    var body: some View {
        HStack(spacing: 10) {
            KFImage(URL(string: model.cover))
            //.placeholder { Placeholder(style: .activity(ratio: Defaults.ImageSize.headerAspect)) }.defaultModifier()
                .resizable()
                .scaledToFit().frame(width: 100, height: 75)
                .cornerRadius(2)
            VStack(alignment: .leading) {
                Text(model.title).foregroundColor(.secondary).bold().lineLimit(3).font(.system(size: 20)).padding(.bottom, 2)
            }
            .font(.caption)
            Spacer()
        }
        .frame(width: UIScreen.screenWidth - 20, height: 75.0)
        .padding(10)
        //.background(.yellow)
    }
}

#Preview {
    
    let preview = VideoModel(
        title: "【米奇17號】[輔12] 終極預告，3月6日 (週四) 死活都要看 (1:10)",
        href: "",
        cover: "https://img.youtube.com/vi/RS1WWDWpL9U/sddefault.jpg"
    )
    VideoCell(model: preview)
}
