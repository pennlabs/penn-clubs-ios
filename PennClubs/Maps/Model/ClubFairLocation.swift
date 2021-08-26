//
//  ClubLocationModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/7/2021.
//

import Foundation

struct ClubFairLocation: Codable {
    let code: String
    let name: String
    let imageUrl: String?
    let lat: Double
    let lon: Double
    let subtitle: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case imageUrl
        case lat
        case lon
        case subtitle
    }
}
