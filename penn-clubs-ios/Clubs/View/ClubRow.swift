//
//  ClubRow.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import Kingfisher

struct ClubRow: View {
    
    var club : ClubModel
    
    init (for club: ClubModel) {
        self.club = club
    }
    
    var body: some View {
        HStack(spacing: 13) {
            if let imageURL = club.imageURL {
                KFImage(URL(string: imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            }
                
            VStack(alignment: .leading, spacing: 0) {
                Text(club.name)
                    .font(.system(size: 17, weight: .medium))
                    .minimumScaleFactor(0.2)
                    .lineLimit(club.name.count < 20 ? 1 : club.name.count < 20 ? 2 : 3)
//                    .background(Color.purple)
                                
                FadingScrollView(fadeDistance: 10, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(club.tags, id: \.id) { tag in
                            Text(tag.name)
                                .padding(.vertical, 3)
                                .padding(.horizontal, 4)
                                .background(Color(UIColor.lightGray))
                                .font(.system(size: 12, weight: .light))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
                
                Text(club.subtitle)
                    .font(.system(size: 10, weight: .light))
                    .frame(minHeight: 40, alignment: .topLeading)
                
                Spacer()
            }
        }.frame(height: 100)
    }
}

//struct ClubRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ClubRow()
//    }
//}
