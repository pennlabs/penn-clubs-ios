//
//  EventCard.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 24/8/2021.
//

import SwiftUI
import Kingfisher

struct EventCard: View {
    let event: Event
    
    init(for event: Event) {
        self.event = event
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageUrl = event.imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 200)
                    .clipped()
            }

            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(Date.humanReadableDuration(from: event.startTime, to: event.endTime))
                        .font(.system(.subheadline))

                    Text(Date().humanReadableDistanceFrom(event.startTime))
                        .font(.system(.caption))

                    Text(event.clubName)
                        .font(.system(.headline))
                        .fontWeight(.bold)

                    Text(event.name)
                        .font(.system(.body))
                }.padding()
                
                Spacer()
            }
        }
        .frame(maxHeight: 400)
        .background(Color.uiCardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
    }
}
