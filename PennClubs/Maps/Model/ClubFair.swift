//
//  ClubLocationModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/7/2021.
//

import Foundation
import Alamofire
import MapKit

struct ClubFair: Codable, Identifiable {
    var id: UUID {
        UUID()
    }

    let code: String
    let name: String
    let imageUrl: String?
    
    var lat: Double
    var long: Double
    let subtitle: String
    var start: Date
    var end: Date
    var isGenerated: Bool = false
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        set {
            lat = newValue.latitude
            long = newValue.longitude
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case code = "club"
        case name
        case imageUrl = "image_url"
        case lat
        case long
        case subtitle
        case start = "start_time"
        case end = "end_time"
    }
    
    var isShown: Bool {
        start.day == Date().day && end > Date()
    }
}
