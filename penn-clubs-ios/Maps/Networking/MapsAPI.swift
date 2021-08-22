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
    let clubBookmarkUrl = "https://pennclubs.com/api/favorites/"
    let clubSubscriptionUrl = "https://pennclubs.com/api/subscriptions/"
    
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
    
    func searchClub(for queryString: String, _ completion: @escaping (_ result: Result<[String], NetworkingError>) -> Void) {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request(URL(string: clubSearchUrl + queryString.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "+"))!).responseDecodable(of: ClubResponse.self, decoder: decoder) { response in
            switch response.result {
            case .success(let clubResponse):
                return completion(.success(clubResponse.items.map({ $0.name })))
            case .failure(.sessionTaskFailed):
                return completion(.failure(.noInternet))
            case .failure:
                return completion(.failure(.serverError))
            }
        }
    }
    
    func getBookMarkedClub(token: WKAccessToken, _ completion: @escaping (_ result: Result<[Club], NetworkingError>) -> Void) {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let request = URLRequest(url: URL(string: clubBookmarkUrl)!, accessToken: token)
        
        AF.request(request).responseDecodable(of: [ClubBookmarkResponse].self, decoder: decoder) { response in
            switch response.result {
            case .success(let clubBookmarkResponse):
                return completion(.success(clubBookmarkResponse.map({ $0.club })))
            case .failure(.sessionTaskFailed):
                return completion(.failure(.noInternet))
            case .failure:
                return completion(.failure(.serverError))
            }
        }
    }
    
    func getSubscriptionClub(token: WKAccessToken, _ completion: @escaping (_ result: Result<[Club], NetworkingError>) -> Void) {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let request = URLRequest(url: URL(string: clubSubscriptionUrl)!, accessToken: token)
        
        AF.request(request).responseDecodable(of: [ClubBookmarkResponse].self, decoder: decoder) { response in
            switch response.result {
            case .success(let clubSubscriptionResponse):
                return completion(.success(clubSubscriptionResponse.map({ $0.club })))
            case .failure(.sessionTaskFailed):
                return completion(.failure(.noInternet))
            case .failure:
                return completion(.failure(.serverError))
            }
        }
    }
}


