//
//  penn_clubsApp.swift
//  penn-clubs
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

@main
struct penn_clubsApp: App {
        
    @StateObject var alertManager = AlertManager.shared
    @StateObject var loginManager = LoginManager()
    @StateObject var controllerModel = ControllerModel()
    @StateObject var clubsMapVM = ClubsMapViewModel()
    
    init() {
        LoginManager.setupCredentials(clientID: "CJmaheeaQ5bJhRL0xxlxK3b8VEbLb3dMfUAvI2TN", redirectURI: "https://pennlabs.org/pennmobile/ios/callback/")
    }
    
    @State var test = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if loginManager.loginState != .loggedOut {
                    ContentView()
                }
                
                LoginSplashScreen()
                    .opacity(loginManager.loginState == .loggedOut ? 1 : 0)
                    .animation(.default)

                AlertView()
            }
            .alert(isPresented: $loginManager.alertIsDisplayed) {
                Alert(title: Text("Login Error"), message: Text("Please login to use this feature"), primaryButton: .cancel(Text("OK"), action: {
                    loginManager.alertHandler()
                }), secondaryButton: .default(Text("Login"), action: { loginManager.toggleLoginSheet() }))
            }
            .sheet(isPresented: $loginManager.loginSheetIsDisplayed) {
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
        VStack {
            Text("")
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea(.all)
    }
}
