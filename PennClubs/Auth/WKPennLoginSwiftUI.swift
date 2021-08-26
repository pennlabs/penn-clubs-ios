//
//  WKPennLoginSwiftUI.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 15/7/2021.
//

import Foundation
import SwiftUI
import WebKit

struct WKPennLoginSwiftUI: UIViewRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginManager: LoginManager
    @State var geometry: GeometryProxy
    
    func makeUIView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        
        return WKPennLoginController(frame: geometry.frame(in: .local), configuration: webConfiguration, delegate: self)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

extension WKPennLoginSwiftUI: WKPennLoginDelegate {
    func handleLogin(user: WKPennUser) {
        loginManager.loginState = .loggedIn
        presentationMode.wrappedValue.dismiss()
    }
     
    func handleError(error: WKPennLoginError) {
        presentationMode.wrappedValue.dismiss()
    }
}

