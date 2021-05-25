//
//  TabController.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct HomeTabView<Content: View>: View {
    let view: Content
    let labelImage: Image
    let navTitle: String
    
    init(_ view: Content, navTitle: String, labelImage: Image) {
        self.view = view
        self.labelImage = labelImage
        self.navTitle = navTitle
    }
    
    var body: some View {
        view
            .tabItem {
                Label(
                    title: { Text(navTitle) },
                    icon: { labelImage }
                )
            }
    }
}
