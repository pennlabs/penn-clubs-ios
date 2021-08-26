//
//  LoginSplashScreen.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 24/8/2021.
//

import Foundation
import SwiftUI

struct LoginSplashScreen: View {
    
    @EnvironmentObject var loginManager: LoginManager
    
    let color1 = Color.init(red: 0.04, green: 0.53, blue: 0.80)
    let color2 = Color.init(red: 0.10, green: 0.56, blue: 0.87)
    let color3 = Color.init(red: 0.12, green: 0.47, blue: 0.81)
    
    var body: some View {
        GeometryReader { reader in
            
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image("LaunchIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .shadow(radius: 3)
                    
                    Text("Penn Clubs")
                        .font(.custom("Avenir-Medium", fixedSize: 25))
                    
                    Spacer().frame(height: 70)
                    
                    Button(action: {
                        loginManager.toggleLoginSheet()
                    }) {
                        Text("LOG IN WITH PENNKEY")
                            .font(.custom("Avenir-Medium", fixedSize: 15))
                            .foregroundColor(.white)
                            .frame(width: 250, height: 40)
                            .background(LinearGradient(gradient: Gradient(stops: [.init(color: color1, location: 0), .init(color: color2, location: 0.3), .init(color: color3, location: 1)]), startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 0)))
                            .cornerRadius(20)
                            .shadow(radius: 3)
                    }
                    
                    Button(action: {
                        loginManager.loginState = .guest
                        UserDefaults.standard.setIsGuestMode(value: true)
                    }) {
                        Text("CONTINUE AS GUEST")
                            .font(.custom("Avenir-Medium", fixedSize: 15))
                            .frame(width: 250, height: 40)
                            .background(Color.uiBackground)
                            .foregroundColor(.blueDark)
                            .foregroundColor(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(LinearGradient(gradient: Gradient(stops: [.init(color: color1, location: 0), .init(color: color2, location: 0.3), .init(color: color3, location: 1)]), startPoint: .init(x: 0, y: 0), endPoint: .init(x: 1, y: 0)), lineWidth: 2)
                            )
                            .shadow(radius: 3)
                    }
                    
                    Spacer().frame(height: reader.frame(in: .global).height * 0.35)
                }
                Spacer()
            }
        }
        .background(Color.uiBackground)
        .edgesIgnoringSafeArea(.all)
    }
}
