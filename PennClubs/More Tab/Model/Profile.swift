//
//  ProfileModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 15/7/2021.
//

import Foundation

struct Profile: Codable, Identifiable, Hashable {
    
    static var directory: String = "profile.json"
    
    static var defaultModel = Profile(email: "", graduationYear: 2020, hasBeenPrompted: false, imageUrl: nil, isSuperuser: false, major: Set<Major>(), name: "", school: Set<School>(), shareBookmarks: false, showProfile: false, username: "")
    
    var id: String {
        return username
    }
    
    let email: String
    var graduationYear: Int
    let hasBeenPrompted: Bool
    var imageUrl: String?
    let isSuperuser: Bool
    var major: Set<Major>
    let name: String
    var school: Set<School>
    var shareBookmarks: Bool
    var showProfile: Bool
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
