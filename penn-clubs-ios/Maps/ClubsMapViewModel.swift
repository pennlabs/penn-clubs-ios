//
//  ClubsMapViewModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 25/7/2021.
//

import MapKit
import SwiftUI

class ClubsMapViewModel: ObservableObject {
    
    @Published var region = MKCoordinateRegion(center: .init(latitude: 39.951830, longitude: -75.194855), latitudinalMeters: 600, longitudinalMeters: 600)
    @Published var clubFairLocations = [ClubFairLocation]()
    @Published var searchClubName = [String]()
    @Published var networkingError: NetworkingError? = nil
    
    private var allClubFairLocations = [ClubFairLocation]()

    init() {
        fetchClubFairLocations()
    }
    
    func fetchClubFairLocations() {
        MapsAPI.instance.getClubsFairLocation { result in
            switch result {
            case .success(let clubFairLocations):
                self.allClubFairLocations = clubFairLocations
                self.clubFairLocations = clubFairLocations
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func resetClubFairLocations() {
        clubFairLocations = allClubFairLocations
    }
    
    func handleFilterType(for filterType: FilterType, isLoggedIn: Bool) {
        switch filterType {
        case .bookmark:
            filterBookmarkedClubs(isLoggedIn: isLoggedIn)
        case .subscription:
            filterSubscriptionClubs()
//        case .search:
//            resetClubFairLocations()
        }
    }
    
    func selectClub(of clubCode: String) {
        clubFairLocations = allClubFairLocations.filter({ $0.code == clubCode })
    }
    
    func searchClub(queryString: String) {
        if !queryString.isEmpty {
            MapsAPI.instance.searchClub(for: queryString) { result in
                switch result {
                case .success(let clubNames):
                    let candidates = self.allClubFairLocations.filter({ Set(clubNames).contains($0.name) }).map({ $0.name })
                    let finalNames = (candidates.count > 5) ? Array(candidates.prefix(upTo: 5)) : candidates
                    self.searchClubName = Array(finalNames)
//                    self.networkingError = .noInternet
                case .failure(let error):
                    self.networkingError = error
                }
            }
        } else {
            searchClubName = []
        }
    }
    
    func focusOnClub(name: String) {
        searchClubName = []
        clubFairLocations = allClubFairLocations.filter({ $0.name == name })
    }
    
    func filterBookmarkedClubs(isLoggedIn: Bool) {
        if isLoggedIn {
            WKPennNetworkManager.instance.getAccessToken { token in
                guard let token = token else { self.networkingError = .authenticationError; return }
                
                MapsAPI.instance.getBookMarkedClub(token: token) { result in
                    switch result {
                    case .success(let clubs):
                        let codeMap = Set(clubs.map({ $0.code }))
                        print(codeMap)
                        self.clubFairLocations = self.allClubFairLocations.filter({ codeMap.contains($0.code) })
                    case .failure(let error):
                        print(error)
                        self.networkingError = error
                    }
                }
            }
        } else {
            let bookmarkedClubCodes = UserDefaults.standard.getBookmarkedClubCodes()
            clubFairLocations = allClubFairLocations.filter( { Set(bookmarkedClubCodes).contains($0.code) })
        }
    }
    
    func filterSubscriptionClubs() {
        WKPennNetworkManager.instance.getAccessToken { token in
            guard let token = token else { self.networkingError = .authenticationError; return }
            
            MapsAPI.instance.getSubscriptionClub(token: token) { result in
                switch result {
                case .success(let clubs):
                    let codeMap = Set(clubs.map({ $0.code }))
                    self.clubFairLocations = self.allClubFairLocations.filter({ codeMap.contains($0.code) })
                case .failure(let error):
                    print(error)
                    self.networkingError = error
                }
            }
        }
    }
}



