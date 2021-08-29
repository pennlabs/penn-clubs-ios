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
    
    func getClubsFairLocation(_ completion: @escaping (_ result: Result<[ClubFair], NetworkingError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        AF.request(URL(string: "https://pennclubs.com/api/booths/")!).responseDecodable(of: [ClubFair].self, decoder: decoder) { response in
            switch response.result {
            case .success(let clubFairLocations):
                return completion(.success(clubFairLocations.filter({ $0.start.day == Date().day && $0.end > Date()})))
            case .failure(.sessionTaskFailed):
                return completion(.failure(.noInternet))
            case .failure:
                print(response)
                return completion(.failure(.serverError))
            }
        }
        
    }
}


