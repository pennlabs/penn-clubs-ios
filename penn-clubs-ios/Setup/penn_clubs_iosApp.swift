//
//  penn_clubs_iosApp.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

@main
struct penn_clubs_iosApp: App {
        
    @ObservedObject var modalManager = ModalManager()
    @ObservedObject var alertManager = AlertManager()
//    @ObservedObject var loginManager = LoginManager.instance
    
    init() {
        ControllerModel.shared.prepare()
//        ClubResponseViewModel.instance.prepare()
        WKPennLogin.setupCredentials(clientID: "CJmaheeaQ5bJhRL0xxlxK3b8VEbLb3dMfUAvI2TN", redirectURI: "https://pennlabs.org/pennmobile/ios/callback/")
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                ModalAnchorView()
                AlertView()
            }
            .sheet(isPresented: LoginManager.$instance.isDisplayed) {
                Text("test")
            }
            .environmentObject(modalManager)
            .environmentObject(alertManager)
        }
    }
}
