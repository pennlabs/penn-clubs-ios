//
//  ContentView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var navBarTitle = ControllerModel.shared.displayNames[0]
    @State var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ForEach(0..<ControllerModel.shared.viewControllers.count) { i in
                    HomeTabView(ControllerModel.shared.viewControllers[i], navTitle: ControllerModel.shared.displayNames[i], labelImage: ControllerModel.shared.displayImages[i])
                        .tag(i)
                }
            }
            .navigationBarTitle(navBarTitle)
            .onChange(of: selectedTab) { i in
                navBarTitle = ControllerModel.shared.displayNames[i]
            }
            .toolbar(content: {
                // TODO: Refactor
                ToolbarItem(placement: .navigationBarTrailing) {
                    if (selectedTab ==  3) {
                        Button("Login") {
                            print("Help tapped!")
                        }
                    }
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
