//
//  LoginManager.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 17/7/2021.
//

import Foundation

class LoginManager: ObservableObject {
    static var clientID: String!
    static var redirectURI: String!
    
    public static func setupCredentials(clientID: String, redirectURI: String) {
        LoginManager.clientID = clientID
        LoginManager.redirectURI = redirectURI
    }
    
    @Published var isDisplayed = false
    @Published var isLoggedIn = WKPennNetworkManager.instance.hasRefreshToken()
    
    func toggle() {
        isDisplayed = true
    }
    
    func logout() {
        isLoggedIn = false
        WKPennNetworkManager.instance.clearRefreshToken()
        WKPennNetworkManager.instance.removeToken()

        Storage.remove(Profile.directory, from: .caches)
        Storage.remove(ClubMembership.directory, from: .caches)
    }
}
