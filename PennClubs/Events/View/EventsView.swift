//
//  EventsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 22/8/2021.
//

import SwiftUI
import Kingfisher

struct EventsView: View {
    let events: [Event]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(events) { event in
                    NavigationLink(destination: EventDetailViewSwiftUI(event: event).navigationBarHidden(true)) {
                        EventCard(for: event)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}
