//
//  FilterType.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 25/7/2021.
//

enum FilterType: CaseIterable {
//    case search
    case bookmark
    case subscription
    
    var icon: String {
        switch self {
//        case .search:
//            return "magnifyingglass"
        case .bookmark:
            return "bookmark.fill"
        case .subscription:
            return "bell.fill"
        }
    }
}
