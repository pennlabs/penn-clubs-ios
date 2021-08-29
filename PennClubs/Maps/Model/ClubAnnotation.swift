//
//  ClubAnnotation.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 20/7/2021.
//

import MapKit

class ClubAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let id: String
    let title: String?
    let imageUrl: String?
    let callout: String
    
    init(clubLocationModel: ClubFair) {
        self.title = clubLocationModel.name
        self.id = clubLocationModel.code
        self.imageUrl = clubLocationModel.imageUrl
        self.coordinate = CLLocationCoordinate2D(latitude: clubLocationModel.lat, longitude: clubLocationModel.long)
        self.callout = clubLocationModel.subtitle
    }
}
