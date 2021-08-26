//
//  AlertManager.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 25/5/2021.
//

import SwiftUI

class AlertManager: ObservableObject {
    static var shared: AlertManager  = AlertManager()
    
    @Published var showAlertType: AlertType? = nil
    
    func toggleAlertType(for type: AlertType) {
        DispatchQueue.main.async {
            self.showAlertType = type
        }
    }
}

struct AlertView: View {
    @EnvironmentObject var alertManager: AlertManager
    
    var body: some View {
        VStack {
            if let alert = alertManager.showAlertType {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(alert.title)
                            .foregroundColor(Color.white)
                            .font(.system(.headline))

                        Text(alert.description)
                            .foregroundColor(Color.white)
                            .font(.system(.body))
                    }
                    
                    Spacer()
                }
                .padding()
                .background(alert.color)
                .cornerRadius(8)
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        alertManager.showAlertType = nil
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            alertManager.showAlertType = nil
                        }
                    }
                })
                
            }
            
            Spacer()
        }
    }
}
