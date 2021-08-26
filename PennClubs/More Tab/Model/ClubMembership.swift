//
//  ClubMembership.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 18/7/2021.
//

import Foundation

struct ClubMembership: Codable, Equatable {
    static let directory = "clubMembership.json"
    
    let club: Club
    let role: Int
    let title: String
    var active: Bool
    var isPublic: Bool
    
    enum CodingKeys: String, CodingKey {
        case club
        case role
        case title
        case active
        case isPublic = "public"
    }
    
    var permissions: String {
        return role == 20 ? "Member" : "Admin"
    }
}
