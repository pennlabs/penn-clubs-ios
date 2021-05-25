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
    
    init() {
        ControllerModel.shared.prepare()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                ModalAnchorView()
            }
            .environmentObject(modalManager)
        }
    }
}
