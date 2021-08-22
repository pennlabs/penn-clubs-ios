//
//  ControllerModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import Foundation
import SwiftUI

enum Feature: Int {
    case map = 0
    case events = 1
    case clubs = 2
    case more = 3
}

class ControllerModel: ObservableObject {
    @Published var feature: Feature = .map
    
    init() {
        prepare()
    }
    
    var viewDictionary: [Feature: AnyView]!

    func prepare() {
        viewDictionary = [Feature: AnyView]()
        
        viewDictionary[.map] = AnyView(ClubsMapView())
        viewDictionary[.events] = AnyView(EventsView())
        viewDictionary[.clubs] = AnyView(ClubsView())
        viewDictionary[.more] = AnyView(MoreView())
    }
    
    var viewControllers: [AnyView] {
        return orderedFeatures.map { (title) -> AnyView in
            return viewDictionary[title]!
        }
    }
    
    var orderedFeatures: [Feature] {
        get {
            return [.map, .events, .clubs, .more]
        }
    }
    
    var displayNames: [String] {
        get {
            return ["Map", "Events", "Clubs", "More"]
        }
    }
    
    var displayImages: [Image] {
        get {
            return [Image(systemName: "map"), Image(systemName: "calendar"), Image(systemName: "doc"), Image(systemName: "ellipsis.circle")]
        }
    }
    
    
}
