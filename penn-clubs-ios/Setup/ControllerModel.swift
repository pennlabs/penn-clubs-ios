//
//  ControllerModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import Foundation
import SwiftUI

enum Feature: String {
    case map = "Maps"
    case events = "Events"
    case clubs = "Clubs"
    case more = "More"
}

class ControllerModel: NSObject {

    static var shared = ControllerModel()

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
        return orderedFeatures.map { $0.rawValue }
    }
    
    var displayImages: [Image] {
        return [Image(systemName: "map"), Image(systemName: "calendar"), Image(systemName: "doc"), Image(systemName: "ellipsis.circle")]
    }
    
    
}
