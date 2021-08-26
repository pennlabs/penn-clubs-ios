//
//  EventsAPI.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 23/8/2021.
//

import Foundation
import Alamofire

class EventsAPI {
    static let instance = EventsAPI()
    
    let rootURLString = "https://pennclubs.com/api/clubs/"
    let favoriteEventsURL = "https://pennclubs.com/api/favouriteevents/"
    
    func getClubEvent(for clubCode: String, _ completion: @escaping (_ result: Result<[Event], NetworkingError>) -> Void) {
        var rootURL = URL(string: rootURLString)!
        rootURL.appendPathComponent(clubCode)
        rootURL.appendPathComponent("events")
        
        //https://pennclubs.com/api/clubs/penn-electric-racing/events/?start_time__gte=2021-08-23T00%3A00%3A00.000Z
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "EST")
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:00.000Z"
        
        
        let queryItems = [URLQueryItem(name: "start_time__gte", value: formatter.string(from: Date()))]
         
        let newUrl = rootURL.appending(queryItems)!
        print(newUrl)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        AF.request(newUrl).responseDecodable(of: [Event].self, decoder: decoder) { response in
            print(response)
            if let events = response.value {
                return completion(.success(events))
            } else {
                return completion(.failure(.parsingError))
            }
        }
    }
    
    func getFavoriteClubEvents(token: WKAccessToken, _ completion: @escaping (_ result: Result<[Event], NetworkingError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let request = URLRequest(url: URL(string: favoriteEventsURL)!, accessToken: token)
        
        AF.request(request).responseDecodable(of: [Event].self, decoder: decoder) { response in
            switch response.result {
            case .success(let favoriteEvents):
                return completion(.success(favoriteEvents))
            case .failure(.sessionTaskFailed):
                return completion(.failure(.noInternet))
            case .failure:
                return completion(.failure(.serverError))
            }
        }
    }
}

// https://stackoverflow.com/questions/34060754/how-can-i-build-a-url-with-query-parameters-containing-multiple-values-for-the-s
extension URL {
    /// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    /// URL must conform to RFC 3986.
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            // URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
            return nil
        }
        // append the query items to the existing ones
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems

        // return the url from new url components
        return urlComponents.url
    }
}
