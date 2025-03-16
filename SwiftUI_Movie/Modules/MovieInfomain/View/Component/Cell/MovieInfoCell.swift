//
//  MovieInfoCell.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/3/9.
//

import SwiftUI
import Kingfisher

struct MovieInfoCell: View {
    
    private let model: MovieInfoModel
    
    init(model: MovieInfoModel) {
        self.model = model
    }
    
    var body: some View {
        
        List() {
            Text("").frame(height: (228 * UIScreen.screenWidth) / 160)
            //.placeholder { Placeholder(style: .activity(ratio: Defaults.ImageSize.headerAspect)) }.defaultModifier()
                .listRowBackground(KFImage(URL(string: model.movie_intro_foto)).resizable())
            Text("電影名稱").bold().foregroundColor(.white).font(.system(size: 22))
                .listRowBackground(Color.black)
            Text(model.h1).foregroundColor(.secondary).font(.system(size: 20))
            Text(model.h3).foregroundColor(.secondary).font(.system(size: 20))
            Text("電影分級").bold().foregroundColor(.white).font(.system(size: 22))
                .listRowBackground(Color.black)
            KFImage(URL(string: model.icon))
            //.placeholder { Placeholder(style: .activity(ratio: Defaults.ImageSize.headerAspect)) }.defaultModifier()
                .resizable()
                .scaledToFit().frame(width: 50, height: 50)
                .cornerRadius(2)
            Text("上映日期").bold().foregroundColor(.white).font(.system(size: 22))
                .listRowBackground(Color.black)
            Text(model.release_movie_time).foregroundColor(.secondary).font(.system(size: 20))
            Text("電影長度").bold().foregroundColor(.white).font(.system(size: 22))
                .listRowBackground(Color.black)
            Text(model.length).foregroundColor(.secondary).font(.system(size: 20))
            Text("導演").bold().foregroundColor(.white).font(.system(size: 22))
                .listRowBackground(Color.black)
            Text(model.director).foregroundColor(.secondary).font(.system(size: 20))
            Text("演員").bold().foregroundColor(.white).font(.system(size: 22))
                .listRowBackground(Color.black)
            Text(model.actor).foregroundColor(.secondary).font(.system(size: 20))
        }
        .listStyle(.inset)
    }
}

#Preview {
    let preview = MovieInfoModel(
        h1: "風之谷",
        h3: "Kaze no tani no Naushika",
        movie_intro_foto: "http://www.atmovies.com.tw/photo101/fzatm0733001/pm_fzatm0733001_0002.jpg",
        icon: "https://seo.docs.com.tw/cinema/photo/5140_1.png",
        release_movie_time: "2025/3/9",
        length: "片長：136分 ",
        director: "宮崎駿 Miyazaki Hayao",
        actor: "島本須美 Sumi Shimamoto............娜烏西卡\n辻村真人............基爾\n納谷悟朗............猶巴\n永井一郎 Ichiro Nagai............米特\n宮內幸平............戈爾\n八奈見乘兒............基利\n京田尚子............祖奶奶\n松田洋治 Yoji Matsuda............阿斯貝魯\n富永美衣奈............拉絲黛兒\n榊原良子............庫夏娜\n家弓家正............克羅托瓦"
    )
    MovieInfoCell(model: preview)
}
