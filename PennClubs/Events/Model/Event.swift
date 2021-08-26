//
//  Event.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 22/8/2021.
//

import Foundation

struct Event: Codable, Identifiable {
    let id: Int
    let description: String
    let endTime: Date
    let imageUrl: String?
    let isIcsEvent: Bool
    let largeImageUrl: String?
    let location: String?
    let name: String
    let startTime: Date
    let url: String?
    let clubName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case endTime = "end_time"
        case imageUrl = "image_url"
        case isIcsEvent = "is_ics_event"
        case largeImageUrl = "large_image_url"
        case location
        case name
        case startTime = "start_time"
        case url
        case clubName = "club_name"
    }
}
