//
//  ClubDetailViewViewModel.swift
//  PennClubs
//
//  Created by CHOI Jongmin on 28/8/2021.
//

import Foundation

class ClubDetailViewModel: ObservableObject {
    @Published var extendedClub: ExtendedClub? = nil
    @Published var faqs: [QuestionAnswer]? = nil
    @Published var events: [Event]? = nil
    @Published var clubFair: ClubFair? = nil
    
    @Published var isLoading = true
    
    func fetchData(_ isLoggedIn: Bool, clubCode: String, name: String, imageUrl: String?, subtitle: String) {
        getExtendedClubModel(code: clubCode, isLoggedIn: isLoggedIn, name: name, imageUrl: imageUrl, subtitle: subtitle)
        getClubFaq(code: clubCode)
        getClubEvent(code: clubCode)
    }
    
    func getExtendedClubModel(code: String, isLoggedIn: Bool, name: String, imageUrl: String?, subtitle: String) {
        isLoading = true
        WKPennNetworkManager.instance.getAccessToken { token in
            EventsAPI.instance.getClubFair(clubCode: code) { result in
                switch result {
                case .success(let clubFair):
                    if let clubFair = clubFair {
                        self.clubFair = clubFair
                    } else {
                        self.clubFair = ClubFair(code: code, name: name, imageUrl: imageUrl, lat: 39.951830, long: -75.194855, subtitle: subtitle, start: Date().nearestHour(), end: Date().nearestHour().addingTimeInterval(3600*2), isGenerated: true)
                    }
                case .failure(let error):
                    AlertManager.shared.toggleAlertType(for: error)
                }
                
                ClubsAPI.instance.fetchExtendedClub(token: token, for: code) { result in
                    switch result {
                    case .success(let extendedClub):
                        self.extendedClub = extendedClub
                        
                        if (!isLoggedIn && UserDefaults.standard.getBookmarkedClubCodes().contains(code)) {
                            self.extendedClub?.isFavorite = true
                        }

                    case .failure(let error):
                        AlertManager.shared.toggleAlertType(for: error)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    func getClubFaq(code: String) {
        ClubsAPI.instance.fetchClubFaq(for: code) { result in
            switch result {
            case .success(let faqs):
                self.faqs = faqs
            case .failure(let error):
                AlertManager.shared.toggleAlertType(for: error)
                self.faqs = []
            }
        }
    }
    
    func getClubEvent(code: String) {
        EventsAPI.instance.getClubEvent(for: code) { result in
            switch result {
            case .success(let events):
                self.events = events
            case .failure(let error):
                AlertManager.shared.toggleAlertType(for: error)
                self.events = []
            }
        }
    }
    
    func registerClubFair() {
        EventsAPI.instance.postClubFair(clubFair: clubFair!) { result in
            switch result {
            case .success:
                self.clubFair?.isGenerated = false
            case .failure(let error):
                AlertManager.shared.toggleAlertType(for: error)
            }
        }
    }
    
    func toggleSubscribe(clubCode: String) {
        if let extendedClub = extendedClub {
            WKPennNetworkManager.instance.getAccessToken { token in
                guard let token = token else {
                    AlertManager.shared.toggleAlertType(for: NetworkingError.authenticationError)
                    return
                }
                
                if extendedClub.isSubscribe {
                    ClubsAPI.instance.deleteSubscribeClub(token: token, clubCode: clubCode) { result in
                        switch result {
                        case .success:
                            self.extendedClub?.isSubscribe.toggle()
                        case .failure(let error):
                            AlertManager.shared.toggleAlertType(for: error)
                        }
                    }
                } else {
                    ClubsAPI.instance.postSubscribeClub(token: token, clubCode: clubCode) { result in
                        switch result {
                        case .success:
                            self.extendedClub?.isSubscribe.toggle()
                        case .failure(let error):
                            AlertManager.shared.toggleAlertType(for: error)
                        }
                    }
                }
            }
        }
    }
    
    func toggleBookmark(clubCode: String) {
        if let extendedClub = extendedClub {
            WKPennNetworkManager.instance.getAccessToken { token in
                guard let token = token else {
                    AlertManager.shared.toggleAlertType(for: NetworkingError.authenticationError)
                    return
                }
                
                if extendedClub.isFavorite {
                    ClubsAPI.instance.deleteBookmarkClub(token: token, clubCode: clubCode) { result in
                        switch result {
                        case .success:
                            self.extendedClub?.isFavorite.toggle()
                        case .failure(let error):
                            AlertManager.shared.toggleAlertType(for: error)
                        }
                    }
                } else {
                    ClubsAPI.instance.postBookmarkClub(token: token, clubCode: clubCode) { result in
                        switch result {
                        case .success:
                            self.extendedClub?.isFavorite.toggle()
                        case .failure(let error):
                            AlertManager.shared.toggleAlertType(for: error)
                        }
                    }
                }
            }
        }
    }
    
}
