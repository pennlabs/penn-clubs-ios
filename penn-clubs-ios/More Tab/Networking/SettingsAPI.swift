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
    
    func fetchSettingsProfile(_ completion: @escaping (_ result: Result<ProfileModel, NetworkingError>) -> Void) {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else {
                return completion(.failure(.authenticationError))
            }
            
            let url = URL(string: self.profileUrl)!
            let request = URLRequest(url: url, accessToken: token)
            
            AF.request(request).responseDecodable(of: ProfileModel.self) { response in
                print(response)
                if let profile = response.value {
                    return completion(.success(profile))
                } else {
                    return completion(.failure(.parsingError))
                }
            }
        }
    }
    
}
