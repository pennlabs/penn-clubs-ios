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
                if let profile = response.value {
                    print(profile)
                    return completion(.success(profile))
                } else {
                    return completion(.failure(.parsingError))
                }
            }
        }
    }
    
    func fetchClubMembership(_ completion: @escaping (_ result: Result<[Club], NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let url = URL(string: self.membershipUrl)!
            let request = URLRequest(url: url, accessToken: token)
            
            AF.request(request).responseDecodable(of: [Club].self) { response in
                if let clubs = response.value {
                    return completion(.success(clubs))
                } else {
                    return completion(.failure(.parsingError))
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
                if let majors = response.value {
                    return completion(.success(majors))
                } else {
                    return completion(.failure(.parsingError))
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
                
                if let schools = response.value {
                    return completion(.success(schools))
                } else {
                    return completion(.failure(.parsingError))
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
                print(response)
                if let clubMembership = response.value {
                    print(response)
                    return completion(.success(clubMembership))
                } else {
                    return completion(.failure(.parsingError))
                }
            }
        }
    }
    
    
    func updateProfile(for profile: Profile, completion: @escaping (_ success: Result<Profile, NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let encoder = JSONEncoder()
            let updateProfileData = try? encoder.encode(profile)
            
            let url = URL(string: self.profileUrl)!
            let request = URLRequest(url: url, accessToken: token, method: .patch, body: updateProfileData)
            
//            print(updateProfileData)
            
            AF.request(request).responseString {
                print($0)
            }
            
            AF.request(request).responseDecodable(of: Profile.self) { response in
                if let profile = response.value {
                    return completion(.success(profile))
                } else {
                    return completion(.failure(.parsingError))
                }
            }
        }
    }
}
