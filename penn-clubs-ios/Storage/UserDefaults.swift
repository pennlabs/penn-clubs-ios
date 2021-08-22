//
//  UserDefaults.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 17/7/2021.
//

import Foundation

//MARK: UserDefaultsKeys
extension UserDefaults {
    enum UserDefaultsKeys: String, CaseIterable {
        case hasLaunched
        
        case bookmarkedClubCodes
    }
    
    func clearAll() {
        for key in UserDefaultsKeys.allCases {
            removeObject(forKey: key.rawValue)
        }
    }
    
    func hasLaunched() -> Bool {
        let temp = bool(forKey: UserDefaultsKeys.hasLaunched.rawValue)
        set(true, forKey: UserDefaultsKeys.hasLaunched.rawValue)
        
        return temp
    }
    
    func saveBookmarkedClubCodes(clubCodes: [String]) {
        set(clubCodes, forKey: UserDefaultsKeys.bookmarkedClubCodes.rawValue)
    }
    
    func getBookmarkedClubCodes() -> [String] {
        let bookmarkedClubCodes = (object(forKey: UserDefaultsKeys.bookmarkedClubCodes.rawValue) as? [String]) ?? []
        return bookmarkedClubCodes
    }
}
