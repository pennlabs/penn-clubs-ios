//
//  ClubModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import Foundation

class ClubResponseViewModel: InfiniteListDataSource<ClubResponse> {
//    static let instance = ClubResponseViewModel()
    
    var searchQuery = ""
    
    override func getUrl(pageNumber: Int) -> String {
        var baseUrl = "https://pennclubs.com/api/clubs/?page=\(pageNumber)"
        
        if !searchQuery.isEmpty {
            baseUrl += "&search=\(searchQuery.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "+"))"
        }
        
        return baseUrl
    }
}

struct ClubResponse: InfiniteListData, Codable {
    static var dateDecodingStrategy: String? = "yyyy-MM-dd"
    
    typealias Item = ClubModel
    
    var hasMorePages: Bool {
        return next != nil
    }
    
    var items: [ClubModel]
    let next: String?
    
    enum CodingKeys: String, CodingKey {
        case items = "results"
        case next
    }
}

struct ClubModel: Codable, Identifiable {
    var id: String {
        return code
    }
    
    let acceptingMembers: Bool
    let active: Bool
    let address: String
    // Int -> application required type?
    let applicationRequiredClassification: Int
    let appointmentNeeded: Bool
    let approved: Bool
    
    let code: String
    let email: String?
    let enablesSubscription: Bool
    let favoriteCount: Int?
    let founded: String?
    let imageURL: String?
    let isFavorite: Bool
    let isMember: Bool
    let isSubscribe: Bool
    let membershipCount: Int?
    let recuritingCycleClassification: Int
    let name: String
    let sizeClassification: Int
    let subtitle: String
    let tags: [Tag]
    
    enum CodingKeys: String, CodingKey {
        case acceptingMembers = "accepting_members"
        case active
        case address
        case applicationRequiredClassification = "application_required"
        case appointmentNeeded = "appointment_needed"
        case approved
        
        case code
        case email
        case enablesSubscription = "enables_subscription"
        case favoriteCount = "favorite_count"
        case founded
        case imageURL = "image_url"
        case isFavorite = "is_favorite"
        case isMember = "is_member"
        case isSubscribe = "is_subscribe"
        case membershipCount = "membership_count"
        case recuritingCycleClassification = "recruiting_cycle"
        case name
        case sizeClassification = "size"
        case subtitle
        case tags
    }
}

struct Tag: Codable {
    let id: Int
    let name: String
}
