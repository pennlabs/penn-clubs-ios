//
//  EventsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import WebKit

struct EventsView: View {
    @State private var showingSheet = false
    
    @EnvironmentObject var alertManager: AlertManager

    var body: some View {
        VStack {
            NavigationLink("test", destination: SwiftUIView())
            
            Button("Show Sheet") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                GeometryReader { reader in
                    WKPennLoginSwiftUI(geometry: reader)
                }
            }
            
            Button("do") {
                WKPennNetworkManager.instance.getAccessToken { token in
                    print(token)
                    let url = URL(string: "https://pennclubs.com/api/favorites/")!
                    let request = URLRequest(url: url, accessToken: token!)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data else {
                            print(String(describing: error))
                            return
                        }
                        
                        print(String(data: data, encoding: .utf8)!)
                    }
                    
                    task.resume()
                }
            }
            
            Button("Error") {
                SettingsAPI.instance.fetchSettingsProfile { result in
                    switch result {
                    case .success(let profile):
                        print(profile)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            Button("Test") {
                LoginManager.instance.toggle()
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
