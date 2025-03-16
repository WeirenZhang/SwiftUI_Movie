//
//  HomeCell.swift
//  SwiftUI_Movie
//
//  Created by User on 2025/2/4.
//

import SwiftUI

struct HomeCell: View {
    
    let model: HomeModel
    
    var body: some View {
        
        GeometryReader { reader in
            
            let fontSize = min(reader.size.width * 0.2, 28)
            let ImageWidth = min(50, reader.size.width * 0.6 )
            
            VStack(spacing: 5) {
                Image(model.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                
                Text(model.title)
                    .font(.system(size: fontSize,weight: .bold, design: .rounded))
                    .foregroundColor(Color.black.opacity(0.9))
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .background(Color.white)
        }
        .frame(height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
    }
}


#Preview {
    //HomeCell()
}
