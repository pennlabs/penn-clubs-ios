//
//  MapsAPI.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 24/7/2021.
//

import MapKit
import Alamofire
import Foundation

class MapsAPI {
    static let instance = MapsAPI()
    
    let clubCoordinateUrl = ""
    let clubSearchUrl = "https://pennclubs.com/api/clubs/?page=1&search="
    
    func getClubsFairLocation(_ completion: @escaping (_ result: Result<[ClubFairLocation], NetworkingError>) -> Void) {
        AF.request(URL(string: "https://pennclubs.com/api/clubs/pennlabs/questions/")!).response { response in
//            if let clubFairLocations = response.value {
//                return completion(.success(clubFairLocations))
//            } else {
//                return completion(.failure(.serverError))
//            }
            let mockData : [ClubFairLocation] = Bundle.main.decode("random_loc.json")
            let mockDataShuffled : [ClubFairLocation] = Array(mockData.prefix(upTo: 100))
            return completion(.success(mockDataShuffled))
        }
    }
}


