//
//  ClubsAPI.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 22/7/2021.
//

import Foundation
import Alamofire

class ClubsAPI {
     
    static let instance = ClubsAPI()
    
    let clubsURL = "https://pennclubs.com/api/clubs/"
    let clubBookmarkUrl = "https://pennclubs.com/api/favorites/"
    let clubSubscriptionUrl = "https://pennclubs.com/api/subscriptions/"
    
    func fetchExtendedClub(token: WKAccessToken?, for code: String, _ completion: @escaping (_ result: Result<ExtendedClub, NetworkingError>) -> Void) {
        
        let url = URL(string: self.clubsURL + code + "/")!
        
        let request: URLRequest
        
        if let token = token {
            request = URLRequest(url: url, accessToken: token)
        } else {
            request = URLRequest(url: url)
        }
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request(request).responseDecodable(of: ExtendedClub.self, decoder: decoder) { response in
            if let extendedClubDetails = response.value {
                return completion(.success(extendedClubDetails))
            } else {
                return completion(.failure(.serverError))
            }
        }
    }
    
    func fetchClub(for code: String, _ completion: @escaping (_ result: Result<Club, NetworkingError>) -> Void) {
        let url = URL(string: self.clubsURL + code)!
        
        let request = URLRequest(url: url)
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request(request).responseDecodable(of: Club.self, decoder: decoder) { response in
            if let clubDetails = response.value {
                return completion(.success(clubDetails))
            } else {
                return completion(.failure(.serverError))
            }
        }
    }
    
    func fetchClubFaq(for code: String, _ completion: @escaping (_ result: Result<[QuestionAnswer], NetworkingError>) -> Void) {
        let url = URL(string: self.clubsURL + code + "/questions/")!
        
        let request = URLRequest(url: url)
        
        AF.request(request).responseDecodable(of: [QuestionAnswer].self) { response in
            if let questionAnswers = response.value {
                return completion(.success(questionAnswers))
            } else {
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
            print(response)
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
    
    func getEvents(for clubCode: String) {
        
    }
}
