//
//  ExtendedClubModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 22/7/2021.
//

import Foundation
import SwiftUI

struct IntegerOrBool: Codable {
    var value: Int

    init(from decoder: Decoder) throws {
        if let int = try? Int(from: decoder) {
            value = int
            return
        }

        value = -1
    }
}

struct ExtendedClub: Codable, Identifiable, Equatable {
    
    static func == (lhs: ExtendedClub, rhs: ExtendedClub) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        return code
    }
    
    var isOwner: Bool {
        return isMember.value == 0 || isMember.value == 10
//        return false
    }

    var memberType: Int {
        return isMember.value
    }
    
    let acceptingMembers: Bool
    let active: Bool
    let address: String
    
    let applicationRequiredClassification: Int
    let appointmentNeeded: Bool
    let approved: Bool
    
    let code: String
    let email: String?
    let enablesSubscription: Bool
    let favoriteCount: Int?
    let founded: Date?
    let imageURL: String?
    let isMember: IntegerOrBool
    
    
    
    // is var to seamless UI updates setting when user is acting as guest user
    var isFavorite: Bool
    var isSubscribe: Bool
    
    let membershipCount: Int
    let recuritingCycleClassification: Int
    let name: String
    let sizeClassification: Int
    let subtitle: String
    let tags: [Tag]
    let badges: [Badges]
    let description: String
    
    let facebook: String?
    let github: String?
    let getInvolvedDescription: String
    let instagram: String?
    let linkedin: String?
    let listserv: String
    let members: [Member]
    
    let twitter: String?
    let website: String?
    let youtube: String?
    
    var hasContacts: Bool {
        return facebook != nil || github != nil || instagram != nil || linkedin != nil || twitter != nil || website != nil || youtube != nil
    }
    
    var contacts: [String?] {
        return [facebook, github, instagram, linkedin, twitter, website, youtube]
    }
    
    var contactsIcon: [String] {
        return ["facebook", "github", "instagram", "linkedin", "twitter", "website", "youtube"]
    }
    
    enum CodingKeys: String, CodingKey {
        case acceptingMembers = "accepting_members"
        case active
        case address
        case applicationRequiredClassification = "application_required"
        case appointmentNeeded = "appointment_needed"
        case approved
        case isMember = "is_member"
        
        case code
        case email
        case enablesSubscription = "enables_subscription"
        case favoriteCount = "favorite_count"
        case founded
        case imageURL = "image_url"
        case isFavorite = "is_favorite"
        
        case isSubscribe = "is_subscribe"
        case membershipCount = "membership_count"
        case recuritingCycleClassification = "recruiting_cycle"
        case name
        case sizeClassification = "size"
        case subtitle
        case tags
        case badges
        case description
        case facebook
        case github
        case getInvolvedDescription = "how_to_get_involved"
        case instagram
        case linkedin
        case listserv
        case members
        
        case twitter
        case website
        case youtube
    }
}

// MARK:- Classification Description
extension ExtendedClub {
    var applicationRequiredDescription: String {
        switch applicationRequiredClassification {
        case 1:
            return "Open Membership"
        case 2:
            return "Tryout Required"
        case 3:
            return "Audition Required"
        case 4:
            return "Application Required"
        default:
            return "Application and Interview Required"
        }
    }
    
    var recuritingCycleDescription: String {
        switch recuritingCycleClassification {
        case 1:
            return "Unknown"
        case 2:
            return "Fall Semester"
        case 3:
            return "Spring Semester"
        case 4:
            return "Both Semesters"
        default:
            return "Open"
        }
    }

    var sizeDescription: String {
        switch sizeClassification {
        case 1:
            return "< 20 Members"
        case 2:
            return "20 - 50 Members"
        case 3:
            return "50 - 100 Members"
        default:
            return "> 100 Members"
        }
    }
    
    var acceptingMembersDescription: String {
        return acceptingMembers ? "Currently Accepting Members" : "Not Currently Accepting Members"
    }
}



struct Badges: Codable {
    let id: Int
    let purpose: String
    let label: String
    let color: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case purpose
        case label
        case color
        case description
    }
}

struct Member: Codable, Identifiable {
    let active: Bool
    let email: String?
    let image: String?
    let name: String
    let isPublic: Bool
    let title: String
    let username: String?
    let description: String
    
    var id: String {
        return username ?? "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case active
        case email
        case image
        case name
        case isPublic = "public"
        case title
        case username
        case description
    }
}
