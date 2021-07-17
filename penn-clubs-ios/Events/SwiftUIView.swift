//
//  SwiftUIView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 15/7/2021.
//

import SwiftUI

struct SwiftUIView: View {
    @EnvironmentObject var alertManager: AlertManager
    
    var body: some View {
        Button("Error") {
            alertManager.toggleAlertType(for: .authenticationError)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
