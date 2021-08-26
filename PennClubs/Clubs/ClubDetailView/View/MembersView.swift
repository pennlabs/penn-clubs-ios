//
//  MembersView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 23/7/2021.
//

import SwiftUI
import Kingfisher

struct MembersView: View {
    
    let members: [Member]
    
    init (for members: [Member]) {
        self.members = members
    }

    var body: some View {
        List(members, rowContent: MemberRow.init)
    }
}

struct MemberRow: View {
    
    let member: Member
    
    var body: some View {
        HStack {
            if let urlString = member.image, let url = URL(string: urlString) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Circle().frame(width: 50, height: 50)
                    .foregroundColor(.baseLabsBlue)
                    .overlay(Text(member.name.initials))
            }

            VStack(alignment: .leading) {
                Text(member.name)
                    .font(.headline)
                Text(member.title)
                    .font(.caption)
            }
        }
    }
}
