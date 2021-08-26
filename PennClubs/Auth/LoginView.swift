//
//  LoginView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 17/7/2021.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            GeometryReader { reader in
                WKPennLoginSwiftUI(geometry: reader)
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
