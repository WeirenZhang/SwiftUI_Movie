//
//  MovieListCell.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/1/31.
//

import SwiftUI
import Kingfisher

struct MovieListCell: View {
    
    private let model: MovieListModel
    
    init(model: MovieListModel) {
        self.model = model
    }
    
    var body: some View {
        HStack(spacing: 10) {
            KFImage(URL(string: model.thumb))
            //.placeholder { Placeholder(style: .activity(ratio: Defaults.ImageSize.headerAspect)) }.defaultModifier()
                .resizable()
                .scaledToFit().frame(width: 100, height: 143)
                .cornerRadius(2)
            VStack(alignment: .leading) {
                Text(model.title).bold().lineLimit(2).font(.system(size: 20)).padding(.bottom, 2)
                Text(model.en).foregroundColor(.secondary).lineLimit(1).font(.system(size: 16))
                Spacer()
                Text(model.release_movie_time).foregroundColor(.secondary).lineLimit(1).font(.system(size: 16))
            }
            .font(.caption)
            Spacer()
        }
        .frame(width: UIScreen.screenWidth - 20, height: 143.0)
        .padding(10)
        //.background(.yellow)
    }
}

#Preview {
    
    let preview = MovieListModel(
        title: "狠狠愛狠狠愛狠狠愛狠狠愛狠狠愛狠狠愛狠狠愛狠狠愛",
        en: "",
        release_movie_time: "2/7/2025",
        thumb: "https://github.com/"
        + "EhPanda-Team/Imageset/blob/"
        + "main/JPGs/2.jpg?raw=true",
        id: ""
    )
    MovieListCell(model: preview)
}
