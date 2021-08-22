//
//  ClubRow.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import Kingfisher

struct ClubRow: View {
    
    var club : Club
    
    init (for club: Club) {
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
                
            VStack(alignment: .leading, spacing: 5) {
                Text(club.name)
                    .font(.system(.body))
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                                
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
                }.frame(height: 20)
                
                Text(club.subtitle)
                    .font(.system(size: 10, weight: .light))
                    .truncationMode(.tail)
                    .frame(maxHeight: 40)
                
                Spacer()
            }.frame(minHeight: 100)
        }
    }
}
