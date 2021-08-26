//
//  LoginManager.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 17/7/2021.
//

import Foundation

enum LoginState {
    case loggedIn
    case loggedOut
    case guest
}

class LoginManager: ObservableObject {
    static var clientID: String!
    static var redirectURI: String!
    
    public static func setupCredentials(clientID: String, redirectURI: String) {
        LoginManager.clientID = clientID
        LoginManager.redirectURI = redirectURI
    }
    
    @Published var loginState: LoginState = .loggedOut
    @Published var loginSheetIsDisplayed = false
    @Published var alertIsDisplayed = false
    @Published var alertHandler: () -> Void = {}
    
    public var isLoggedIn: Bool {
        return loginState == .loggedIn
    }
    
    init() {
        if WKPennNetworkManager.instance.hasRefreshToken() {
            loginState = .loggedIn
        } else {
            if UserDefaults.standard.isGuestMode() {
                loginState = .guest
            } else {
                loginState = .loggedOut
            }
        }
    }
    
    func toggleLoginSheet() {
        loginSheetIsDisplayed = true
    }
    
    func toggleAlert(handler: @escaping () -> Void) {
        alertHandler = handler
        alertIsDisplayed = true
    }
    
    func logout() {
        loginState = .loggedOut
        UserDefaults.standard.clearAll()
        
        WKPennNetworkManager.instance.clearRefreshToken()
        WKPennNetworkManager.instance.removeToken()

        Storage.remove(Profile.directory, from: .caches)
        Storage.remove(ClubMembership.directory, from: .caches)
    }
}
