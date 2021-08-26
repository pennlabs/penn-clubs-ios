//
//  ContentView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var controllerModel: ControllerModel
    
    @State var logoutAlert = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $controllerModel.feature) {
                ForEach(0..<controllerModel.orderedFeatures.count) { i in
                    HomeTabView(controllerModel.viewControllers[i], navTitle: controllerModel.tabTitle[i], labelImage: controllerModel.displayImages[i])
                        .tag(controllerModel.orderedFeatures[i])
                }
            }
            .alert(isPresented: $logoutAlert) {
                Alert(title: Text("Are you sure?"), message: Text("Please confirm that you wish to logout."), primaryButton: .cancel(), secondaryButton: .default(Text("Confirm"), action: {
                    withAnimation {
                        loginManager.logout()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        controllerModel.feature = .home
                    }
                }))
            }
            .navigationBarTitle(controllerModel.navigationTitle[controllerModel.feature.rawValue], displayMode: .large)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if (controllerModel.feature == .more) {
                        loginButton
                    }
                }
            })
        }
    }
    
    var loginButton: some View {
        if loginManager.isLoggedIn {
            return Button("Logout") {
                logoutAlert = true
            }
        } else {
            return Button("Login") {
                withAnimation {
                    loginManager.toggleLoginSheet()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
