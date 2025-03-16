//
//  MovieTimeResultCell.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/3/13.
//

import SwiftUI

struct MovieTimeResultCell: View {
    
    let spacing: CGFloat = 10
    @State var numberOfColoun = 3
    
    private let model: MovieTimeResultModel
    
    init(model: MovieTimeResultModel) {
        self.model = model
    }
    
    var body: some View {
        let colunms = Array(repeating: GridItem(.flexible(),spacing: spacing), count: numberOfColoun)
        
        ZStack {
            VStack(alignment: .leading) {
                Text(model.theater).foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))).bold().lineLimit(3).font(.system(size: 22)).padding(.bottom, 2)
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
            }.padding(10).background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
        }.padding(10)
    }
}

#Preview {
    let preview = MovieTimeResultModel(
        id: "",
        theater: "基隆秀泰影城",
        types: [TypesModel(types:[TypeModel(type: "中文版"),TypeModel(type: "數位版"),TypeModel(type: "沙發版")], times: [TimeModel(time: "15：20"),TimeModel(time: "15：30"),TimeModel(time: "15：40")]),TypesModel(types:[TypeModel(type: "中文版")], times: [TimeModel(time: "15：20"),TimeModel(time: "15：30"),TimeModel(time: "15：40")])]
    )
    MovieTimeResultCell(model: preview)
}
