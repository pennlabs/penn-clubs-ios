//
//  EventsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import WebKit

struct EventsView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var controllerModel: ControllerModel
    
    var body: some View {
        VStack {
            Button("Print Access Token") {
                WKPennNetworkManager.instance.getAccessToken {
                    print($0 ?? "Error")
                }
            }
            
            Button("TEST") {
                controllerModel.feature = .clubs
            }
            
            Button("Toggle Alert") {
                AlertManager.shared.toggleAlertType(for: .authenticationError)
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}






struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
