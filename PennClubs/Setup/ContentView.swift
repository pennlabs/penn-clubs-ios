//
//  ContentView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import FirebaseAnalytics

struct ContentView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var controllerModel: ControllerModel
    
    @State var logoutAlert = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $controllerModel.feature) {
                ForEach(controllerModel.orderedFeatures, id: \.self) { feature in
                    controllerModel.viewDictionary[feature]
                        .tabItem {
                            Label(
                                title: { Text(controllerModel.tabTitleDictionary[feature] ?? "ERROR") },
                                icon: { controllerModel.tabImageDictionary[feature] }
                            )
                        }
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
            .navigationBarTitle(controllerModel.navigationTitleDictionary[controllerModel.feature] ?? "ERROR", displayMode: .large)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if (controllerModel.feature == .more) {
                        loginButton
                    }
                }
            })
            .onChange(of: controllerModel.feature) { feature in
                FirebaseAnalytics.Analytics.logEvent("tab_switched", parameters: [
                    AnalyticsParameterScreenName: String.init(describing: feature)
                ])
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
