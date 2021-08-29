//
//  ControllerModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import Foundation
import SwiftUI

enum Feature: Hashable {
    case home
    case map
    case search
    case more
}

class ControllerModel: ObservableObject {
    @Published var feature: Feature = .home
    
    init() {
        prepareViewDictionary()
        prepareTabTitleDictionary()
        prepareTabImageDictionary()
        prepareNavigationTitleDictionary()
    }
    
    var orderedFeatures: [Feature] {
        var date = DateComponents()
        date.year = 2021
        date.month = 9
        date.day = 4
        date.timeZone = TimeZone(abbreviation: "EST")
        let userCalendar = Calendar.current
        let endOfSACFair = userCalendar.date(from: date)
        
        if Date() < endOfSACFair ?? Date() {
            return [.home, .map, .search, .more]
        } else {
            return [.home, .search, .more]
        }
    }
    
    var viewDictionary: [Feature: AnyView]!
    var tabTitleDictionary: [Feature: String]!
    var tabImageDictionary: [Feature: Image]!
    var navigationTitleDictionary: [Feature: String]!

    func prepareViewDictionary() {
        viewDictionary = [Feature: AnyView]()
        
        viewDictionary[.home] = AnyView(HomeView())
        viewDictionary[.map] = AnyView(ClubsMapView())
        viewDictionary[.search] = AnyView(SearchView())
        viewDictionary[.more] = AnyView(MoreView())
    }
    
    func prepareTabTitleDictionary() {
        tabTitleDictionary = [Feature: String]()
        
        tabTitleDictionary[.home] = "Home"
        tabTitleDictionary[.map] = "Clubs Fair"
        tabTitleDictionary[.search] = "Search"
        tabTitleDictionary[.more] = "More"
    }
    
    func prepareTabImageDictionary() {
        tabImageDictionary = [Feature: Image]()
        
        tabImageDictionary[.home] = Image(systemName: "house")
        tabImageDictionary[.map] = Image(systemName: "map")
        tabImageDictionary[.search] = Image(systemName: "magnifyingglass")
        tabImageDictionary[.more] = Image(systemName: "ellipsis.circle")
    }
    
    func prepareNavigationTitleDictionary() {
        navigationTitleDictionary = [Feature: String]()
        
        navigationTitleDictionary[.home] = "Home"
        navigationTitleDictionary[.map] = ""
        navigationTitleDictionary[.search] = "Search"
        navigationTitleDictionary[.more] = "More"
    }
}
