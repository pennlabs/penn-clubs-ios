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
    
    // TODO: Fix auth case
    func fetchClub(for code: String, _ completion: @escaping (_ result: Result<ExtendedClub, NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let url = URL(string: self.clubsURL + code)!
            
            let request = URLRequest(url: url, accessToken: token)
            
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
    
}
