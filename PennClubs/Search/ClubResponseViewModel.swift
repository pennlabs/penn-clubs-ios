//
//  ClubResponseViewModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 25/8/2021.
//

import Foundation

class ClubResponseViewModel: InfiniteListDataSource<ClubResponse> {
    var searchQuery = ""
    
    override func getUrl(pageNumber: Int) -> String {
        var baseUrl = "https://pennclubs.com/api/clubs/?page=\(pageNumber)"
        
        if !searchQuery.isEmpty {
            baseUrl += "&search=\(searchQuery.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "+"))"
        }
        
        return baseUrl
    }
}

struct ClubResponse: InfiniteListData, Codable {
    static var dateDecodingStrategy: String? = "yyyy-MM-dd"
    
    typealias Item = Club
    
    var hasMorePages: Bool {
        return next != nil
    }
    
    var items: [Club]
    let next: String?
    
    enum CodingKeys: String, CodingKey {
        case items = "results"
        case next
    }
}
