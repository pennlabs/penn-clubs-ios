//
//  AlertType.swift
//  PennClubs
//
//  Created by CHOI Jongmin on 25/8/2021.
//

import SwiftUI

// TODO: Find way of migrating color out of this
protocol AlertType {
    var title: String { get }
    var description: String { get }
    var color: Color { get }
}

enum Success: String, AlertType {
    
    case success = "Success"
    case easterEgg = "Easter Egg"
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .easterEgg:
            return "Easter Egg"
        }
    }
    
    var description: String {
        switch self {
        case .success:
            return "Your information has been successfully updated!"
        case .easterEgg:
            return "You discovered the easter egg! From the creators of this app, thank you for using Penn Clubs."
        }
    }
    
    var color: Color {
        switch self {
        case .success:
            return Color.green
        case .easterEgg:
            return Color.yellow
        }
    }
}

enum NetworkingError: String, LocalizedError, AlertType {
    case noInternet = "No Internet"
    case parsingError = "Parsing Error"
    case serverError = "Server Error"
    case jsonError = "JSON Error"
    case authenticationError = "Unable to authenticate"
    case other
    
    var title: String { self.rawValue }
    
    var color: Color { Color.red }
    
    var description: String {
        switch self {
        case .noInternet:
            return "You appear to be offline.\nPlease try again later."
        case .serverError:
            return "Our servers are currently not updating. We hope this will be fixed shortly."
        case .authenticationError:
            return "There seems to be issue your authentication credentials. Please logout and re-login again"
        case .parsingError, .jsonError, .other:
            return "Something went wrong. Please try again later."
        }
    }
}
