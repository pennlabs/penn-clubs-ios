//
//  ClubDetailView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct ClubDetailView: View {
    let club: ClubModel
    
    init(for club: ClubModel) {
        self.club = club
    }
    
    var body: some View {
        Text(club.name)
    }
}
