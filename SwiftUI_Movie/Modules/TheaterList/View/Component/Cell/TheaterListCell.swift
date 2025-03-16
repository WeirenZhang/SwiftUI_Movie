//
//  TheaterListCell.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/3/9.
//

import SwiftUI

struct TheaterListCell: View {
    
    private let model: TheaterInfoModel
    
    init(model: TheaterInfoModel) {
        self.model = model
    }
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading) {
                Text(model.name).bold().lineLimit(2).font(.system(size: 22)).padding(.bottom, 2)
                Text(model.adds).foregroundColor(.secondary).lineLimit(1).font(.system(size: 16)).padding(.bottom, 2)
                Text(model.tel).foregroundColor(.secondary).lineLimit(1).font(.system(size: 16))
            }
            .font(.caption)
            Spacer()
        }.padding(10)
    }
}

#Preview {
    let preview = TheaterInfoModel(
        id: "",
        name: "基隆秀泰影城",
        adds: "基隆市中正區信一路177號",
        tel: "(02)2421-2388"
    )
    TheaterListCell(model: preview)
}
