//
//  ProfileModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 15/7/2021.
//

import Foundation

struct ProfileModel: Codable, Identifiable {
    var id: String {
        return username
    }
    
    let email: String
    let graduationYear: Int
    let hasBeenPrompted: Bool
    let imageUrl: String?
    let isSuperuser: Bool
    let major: [MajorModel]
    let name: String
    let school: [SchoolModel]
    let shareBookmarks: Bool
    let showProfile: Bool
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case graduationYear = "graduation_year"
        case hasBeenPrompted = "has_been_prompted"
        case imageUrl = "image_url"
        case isSuperuser = "is_superuser"
        case major
        case name
        case school
        case shareBookmarks = "share_bookmarks"
        case showProfile = "show_profile"
        case username
    }
}
