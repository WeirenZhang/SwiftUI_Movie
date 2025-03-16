//
//  TheaterTimeResultCell.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/3/13.
//

import SwiftUI
import Kingfisher

struct TheaterTimeResultCell: View {
    
    let spacing: CGFloat = 10
    @State var numberOfColoun = 2
    
    private let model: TheaterTimeResultModel
    
    init(model: TheaterTimeResultModel) {
        self.model = model
    }
    
    var body: some View {
        let colunms = Array(repeating: GridItem(.flexible(),spacing: spacing), count: numberOfColoun)
        ZStack {
            HStack(alignment: .top) {
                KFImage(URL(string: model.release_foto))
                //.placeholder { Placeholder(style: .activity(ratio: Defaults.ImageSize.headerAspect)) }.defaultModifier()
                    .resizable()
                    .scaledToFit().frame(width: 100, height: 143)
                VStack(alignment: .leading) {
                    Text(model.theaterlist_name).foregroundColor(.black).bold().lineLimit(3).font(.system(size: 20)).padding(.bottom, 2)
                    Text(model.length).foregroundColor(.secondary).bold().lineLimit(3).font(.system(size: 18)).padding(.bottom, 2)
                    KFImage(URL(string: model.icon))
                    //.placeholder { Placeholder(style: .activity(ratio: Defaults.ImageSize.headerAspect)) }.defaultModifier()
                        .resizable()
                        .scaledToFit().frame(width: 50, height: 50)
                        .cornerRadius(2).padding(.bottom, 2)
                    ForEach(model.types, id: \.self) { item in
                        LazyVGrid(columns: colunms, spacing: spacing ) {
                            ForEach(item.types, id: \.self) { type in
                                Text(type.type).frame(maxWidth: .infinity, maxHeight: .infinity).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).bold().lineLimit(3).font(.system(size: 20)).padding(.bottom, 2).background(Color(#colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)))
                            }
                        }
                        LazyVGrid(columns: colunms, spacing: spacing ) {
                            ForEach(item.times, id: \.self) { time in
                                Text(time.time).frame(maxWidth: .infinity, maxHeight: .infinity).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))).bold().lineLimit(3).font(.system(size: 20)).padding(.bottom, 2).background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            }
                        }
                    }
                }
            }.padding(10).background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588326)))
            
        }.padding(10)
    }
}

#Preview {
    let preview = TheaterTimeResultModel(
        id: "",
        release_foto: "http://www.atmovies.com.tw/photo101/fmen12299608/pm_fmen12299608_0011.jpg",
        theaterlist_name: "米奇17號",
        length: "片長：136分",
        icon: "https://seo.docs.com.tw/cinema/photo/5140_3.png",
        types: [TypesModel(types:[TypeModel(type: "中文版"),TypeModel(type: "數位版"),TypeModel(type: "沙發版")], times: [TimeModel(time: "15：20"),TimeModel(time: "15：30"),TimeModel(time: "15：40")]),TypesModel(types:[TypeModel(type: "中文版")], times: [TimeModel(time: "15：20"),TimeModel(time: "15：30"),TimeModel(time: "15：40")])]
    )
    TheaterTimeResultCell(model: preview)
}
