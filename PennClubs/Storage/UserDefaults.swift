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
        case isGuestMode
        
        case bookmarkedClubCodes
    }
    
    func clearAll() {
        for key in UserDefaultsKeys.allCases {
            removeObject(forKey: key.rawValue)
        }
    }

    func isGuestMode() -> Bool {
        return bool(forKey: UserDefaultsKeys.isGuestMode.rawValue)
    }
    
    func setIsGuestMode(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isGuestMode.rawValue)
    }
    
    func saveBookmarkedClubCodes(clubCodes: [String]) {
        set(clubCodes, forKey: UserDefaultsKeys.bookmarkedClubCodes.rawValue)
    }
    
    func toggleBookmarkedClubCodes(clubCode: String) {
        var bookmarkedClubCodes = (object(forKey: UserDefaultsKeys.bookmarkedClubCodes.rawValue) as? [String]) ?? []
        
        if bookmarkedClubCodes.contains(clubCode) {
            bookmarkedClubCodes.removeAll(where: { $0 == clubCode })
        } else {
            bookmarkedClubCodes.append(clubCode)
        }
        
        set(bookmarkedClubCodes, forKey: UserDefaultsKeys.bookmarkedClubCodes.rawValue)
    }
    
    func getBookmarkedClubCodes() -> [String] {
        let bookmarkedClubCodes = (object(forKey: UserDefaultsKeys.bookmarkedClubCodes.rawValue) as? [String]) ?? []
        return bookmarkedClubCodes
    }
}
