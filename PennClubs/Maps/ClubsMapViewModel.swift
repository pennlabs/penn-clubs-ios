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
    
    @Published var clubSelectionFilter = false
    
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
        clubSelectionFilter = false
        clubFairLocations = allClubFairLocations
    }
    
    func handleFilterType(for filterType: FilterType, isLoggedIn: Bool) {
        clubSelectionFilter = false

        switch filterType {
        case .bookmark:
            filterBookmarkedClubs(isLoggedIn)
        case .subscription:
            filterSubscriptionClubs(isLoggedIn)
        }
    }
    
    func selectClub(of clubCode: String) {
        clubSelectionFilter = true
        clubFairLocations = allClubFairLocations.filter({ $0.code == clubCode })
    }

    func filterBookmarkedClubs(_ isLoggedIn: Bool) {
        if isLoggedIn {
            WKPennNetworkManager.instance.getAccessToken { token in
                guard let token = token else { AlertManager.shared.toggleAlertType(for: NetworkingError.authenticationError); return }
                
                ClubsAPI.instance.getBookMarkedClub(token: token) { result in
                    switch result {
                    case .success(let clubs):
                        let codeMap = Set(clubs.map({ $0.code }))
                        self.clubFairLocations = self.allClubFairLocations.filter({ codeMap.contains($0.code) })
                    case .failure(let error):
                        AlertManager.shared.toggleAlertType(for: error)
                    }
                }
            }
        } else {
            let bookmarkedClubCodes = UserDefaults.standard.getBookmarkedClubCodes()
            clubFairLocations = allClubFairLocations.filter( { Set(bookmarkedClubCodes).contains($0.code) })
        }
    }
    
    func filterSubscriptionClubs(_ isLoggedIn: Bool) {
        if isLoggedIn {
            WKPennNetworkManager.instance.getAccessToken { token in
                guard let token = token else { AlertManager.shared.toggleAlertType(for: NetworkingError.authenticationError); return }
                
                ClubsAPI.instance.getSubscriptionClub(token: token) { result in
                    switch result {
                    case .success(let clubs):
                        let codeMap = Set(clubs.map({ $0.code }))
                        self.clubFairLocations = self.allClubFairLocations.filter({ codeMap.contains($0.code) })
                    case .failure(let error):
                        AlertManager.shared.toggleAlertType(for: error)
                    }
                }
            }
        } else  {
            clubFairLocations = []
        }
    }
}



