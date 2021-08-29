//
//  WKPennLoginSwiftUI.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 15/7/2021.
//

import Foundation
import SwiftUI
import WebKit

struct WKPennLoginView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginManager: LoginManager
    
    func makeUIViewController(context: Context) -> UIViewController {
        return WKPennLoginController(delegate: self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

extension WKPennLoginView: WKPennLoginDelegate {
    func handleLogin(user: WKPennUser) {
        loginManager.loginState = .loggedIn
        presentationMode.wrappedValue.dismiss()
    }
     
    func handleError(error: WKPennLoginError) {
        AlertManager.shared.toggleAlertType(for: NetworkingError.serverError)
        presentationMode.wrappedValue.dismiss()
    }
}
