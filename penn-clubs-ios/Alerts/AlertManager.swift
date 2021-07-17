//
//  AlertManager.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 25/5/2021.
//

import SwiftUI

class AlertManager: ObservableObject {
    @Published var showAlert: AlertType? = nil
    
    func toggleAlertType(for type: AlertType?) {
        showAlert = type
    }
}

struct AlertView: View {
    @EnvironmentObject var alertManager: AlertManager
    
    var body: some View {
        VStack {
            if let alert = alertManager.showAlert {
                Text(alert.localizedDescription)
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding()
                    .animation(.easeInOut)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .onTapGesture {
                        withAnimation {
                            alertManager.toggleAlertType(for: nil)
                        }
                    }.onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                alertManager.toggleAlertType(for: nil)
                            }
                        }
                    })
            }
            
            Spacer()
        }
    }
}

enum AlertType: String, LocalizedError {
    case noInternet
    case serverError = "Server Error.\nPlease refresh and try again."
    case jsonError = "JSON error"
    case authenticationError = "Unable to authenticate"
    case other
    var localizedDescription: String { return NSLocalizedString(self.rawValue, comment: "") }
}
