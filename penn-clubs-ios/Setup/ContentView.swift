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
    
    var body: some View {
        NavigationView {
            TabView(selection: $controllerModel.feature) {
                ForEach(0..<controllerModel.viewControllers.count) { i in
                    HomeTabView(controllerModel.viewControllers[i], navTitle: controllerModel.displayNames[i], labelImage: controllerModel.displayImages[i])
                        .tag(controllerModel.orderedFeatures[i])
                }
            }
            .navigationBarTitle(controllerModel.displayNames[controllerModel.feature.rawValue], displayMode: .large)
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
                loginManager.logout()
            }
        } else {
            return Button("Login") {
                loginManager.toggle()
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
