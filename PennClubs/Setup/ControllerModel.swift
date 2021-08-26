//
//  ControllerModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import Foundation
import SwiftUI

enum Feature: Int {
    case home = 0
    case map = 1
    case search = 2
    case more = 3
}

class ControllerModel: ObservableObject {
    @Published var feature: Feature = .home
    
    init() {
        prepare()
    }
    
    var viewDictionary: [Feature: AnyView]!

    func prepare() {
        viewDictionary = [Feature: AnyView]()
        
        viewDictionary[.home] = AnyView(HomeView())
        viewDictionary[.map] = AnyView(ClubsMapView())
        viewDictionary[.search] = AnyView(SearchView())
        viewDictionary[.more] = AnyView(MoreView())
    }
    
    var viewControllers: [AnyView] {
        return orderedFeatures.map { (title) -> AnyView in
            return viewDictionary[title]!
        }
    }
    
    var orderedFeatures: [Feature] {
        get {
            return [.home, .map, .search, .more]
        }
    }
    
    var tabTitle: [String] {
        get {
            return ["Home", "Clubs Fair", "Search", "More"]
        }
    }
    
    var navigationTitle: [String] {
        get {
            return ["Home", "", "Search", "More"]
        }
    }
    
    var displayImages: [Image] {
        get {
            return [Image(systemName: "house"), Image(systemName: "map"), Image(systemName: "magnifyingglass"), Image(systemName: "ellipsis.circle")]
        }
    }
    
    
}
