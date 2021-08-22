//
//  AlertManager.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 25/5/2021.
//

import SwiftUI

class AlertManager: ObservableObject {
    static var shared: AlertManager  = AlertManager()
    
    @Published var showAlert: NetworkingError? = nil
    
    func toggleAlertType(for type: NetworkingError) {
        print("showing alert")
        showAlert = type
    }
}

struct AlertView: View {
    @EnvironmentObject var alertManager: AlertManager
    
    var body: some View {
        VStack {
            if let alert = alertManager.showAlert {
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
                .background(Color.red)
                .cornerRadius(8)
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        alertManager.showAlert = nil
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            alertManager.showAlert = nil
                        }
                    }
                })
                
            }
            
            Spacer()
        }
    }
}
