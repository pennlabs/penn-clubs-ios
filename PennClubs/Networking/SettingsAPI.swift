//
//  SettingsAPI.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 16/7/2021.
//

import Foundation
import Alamofire

class SettingsAPI {
    
    static let instance = SettingsAPI()
    
    let profileUrl = "https://pennclubs.com/api/settings/"
    
    let membershipUrl = "https://pennclubs.com/api/memberships/"
    let bookmarkUrl = "https://pennclubs.com/api/favorites/"
    let subscriptionUrl = "https://pennclubs.com/api/subscriptions/"
    let clubRequestUrl = "https://pennclubs.com/api/requests/"
    
    let majorUrl = "https://pennclubs.com/api/majors/"
    let schoolUrl = "https://pennclubs.com/api/schools/"
    
    func fetchSettingsProfile(_ completion: @escaping (_ result: Result<Profile, NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let url = URL(string: self.profileUrl)!
            let request = URLRequest(url: url, accessToken: token)
            
            AF.request(request).responseDecodable(of: Profile.self) { response in
                switch response.result {
                case .success(let profile):
                    return completion(.success(profile))
                case .failure(.sessionTaskFailed):
                    return completion(.failure(.noInternet))
                case .failure:
                    return completion(.failure(.serverError))
                }
            }
        }
    }

    func fetchMajors(_ completion: @escaping (_ result: Result<[Major], NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let url = URL(string: self.majorUrl)!
            let request = URLRequest(url: url, accessToken: token)
        
            AF.request(request).responseDecodable(of: [Major].self) { response in
                switch response.result {
                case .success(let majors):
                    return completion(.success(majors))
                case .failure(.sessionTaskFailed):
                    return completion(.failure(.noInternet))
                case .failure:
                    return completion(.failure(.serverError))
                }
            }
        }
    }
    
    func fetchSchools(_ completion: @escaping (_ result: Result<[School], NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let url = URL(string: self.schoolUrl)!
            let request = URLRequest(url: url, accessToken: token)
        
            AF.request(request).responseDecodable(of: [School].self) { response in
                switch response.result {
                case .success(let schools):
                    return completion(.success(schools))
                case .failure(.sessionTaskFailed):
                    return completion(.failure(.noInternet))
                case .failure:
                    return completion(.failure(.serverError))
                }
            }
        }
    }
    
    func fetchMembership(_ completion: @escaping (_ result: Result<[ClubMembership], NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let url = URL(string: self.membershipUrl)!
            let request = URLRequest(url: url, accessToken: token)
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            AF.request(request).responseDecodable(of: [ClubMembership].self, decoder: decoder) { response in
                switch response.result {
                case .success(let clubsMembership):
                    return completion(.success(clubsMembership))
                case .failure(.sessionTaskFailed):
                    return completion(.failure(.noInternet))
                case .failure:
                    return completion(.failure(.serverError))
                }
            }
        }
    }
    
    func updateProfile(for profile: Profile, completion: @escaping (_ success: Result<Void, NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let encoder = JSONEncoder()
            let updateProfileData = try? encoder.encode(profile)
            
            let url = URL(string: self.profileUrl)!
            var request = URLRequest(url: url, accessToken: token, method: .patch, body: updateProfileData)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            AF.request(request).validate(statusCode: 200..<300).responseDecodable(of: Profile.self) { response in
                switch response.result {
                case .success:
                    return completion(.success(()))
                case .failure(.sessionTaskFailed):
                    return completion(.failure(.noInternet))
                case .failure:
                    return completion(.failure(.serverError))
                }
            }
        }
    }
}
