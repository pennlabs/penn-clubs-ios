//
//  penn_clubs_iosApp.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

@main
struct penn_clubs_iosApp: App {
        
    @StateObject var alertManager = AlertManager.shared
    @StateObject var loginManager = LoginManager()
    @StateObject var controllerModel = ControllerModel()
    @StateObject var clubsMapVM = ClubsMapViewModel()
    
    init() {
        LoginManager.setupCredentials(clientID: "CJmaheeaQ5bJhRL0xxlxK3b8VEbLb3dMfUAvI2TN", redirectURI: "https://pennlabs.org/pennmobile/ios/callback/")
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                AlertView()
                
                if !UserDefaults.standard.hasLaunched() {
                    welcomeScreen
                }
            }
            .sheet(isPresented: $loginManager.isDisplayed) {
                LoginView()
            }
            .environmentObject(alertManager)
            .environmentObject(controllerModel)
            .environmentObject(loginManager)
            .environmentObject(clubsMapVM)
        }
    }
    
    // TODO: Finish splash screen
    var welcomeScreen: some View {
        Text("")
    }
}
