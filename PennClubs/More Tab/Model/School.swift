//
//  School.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 15/7/2021.
//

import Foundation

struct School: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let isGraduate: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isGraduate = "is_graduate"
    }
}
