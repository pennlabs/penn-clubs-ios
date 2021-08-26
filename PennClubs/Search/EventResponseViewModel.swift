//
//  AllEventsViewModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 23/8/2021.
//

import Foundation

class EventResponseViewModel: InfiniteListDataSource<EventResponse> {
    
    override func getUrl(pageNumber: Int) -> String {
        // TODO: get current date and actually send the correct request
        return "https://pennclubs.com/api/events/?page=\(pageNumber)&end_time__gte=2021-07-25T00%3A00%3A00.000Z&start_time__lte=2021-09-06T00%3A00%3A00.000Z"
    }
}

struct EventResponse: InfiniteListData, Codable {
    static var dateDecodingStrategy: String? = "yyyy-MM-dd'T'HH:mm:ssz"
    
    typealias Item = Event
    
    var hasMorePages: Bool {
        return next != nil
    }
    
    var items: [Event]
    let next: String?
    
    enum CodingKeys: String, CodingKey {
        case items = "results"
        case next
    }
}
    

