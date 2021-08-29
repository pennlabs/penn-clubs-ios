//
//  PersonalViewModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 22/8/2021.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var bookmarkedClubs: [Club] = []
    @Published var subscribedClubs: [Club] = []
    @Published var bookmarkedEvents: [Event] = []
    
    @Published var isLoading = true
    
    func fetchData(_ isLoggedIn: Bool) {
        isLoading = true
        getBookmarkedClubs(isLoggedIn: isLoggedIn)
        getEventsOfInterest(isLoggedIn: isLoggedIn)
        getSubscriptionClubs(isLoggedIn: isLoggedIn)
    }
    
    func getBookmarkedClubs(isLoggedIn: Bool) {
        if isLoggedIn {
            WKPennNetworkManager.instance.getAccessToken { token in
                guard let token = token else {
                    AlertManager.shared.toggleAlertType(for: NetworkingError.authenticationError)
                    return
                }
                
                ClubsAPI.instance.getBookMarkedClub(token: token) { result in
                    switch result {
                    case .success(let clubs):
                        self.bookmarkedClubs = clubs
                    case .failure(let error):
                        AlertManager.shared.toggleAlertType(for: error)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                let bookmarkedClubCodes = UserDefaults.standard.getBookmarkedClubCodes()
            
                // Temp is used to avoid jumping animation
                var temp: [Club] = []
                var count = 0
                
                if bookmarkedClubCodes.count == 0 { self.bookmarkedClubs = [] }
                
                for code in bookmarkedClubCodes {
                    ClubsAPI.instance.fetchClub(for: code) { result in
                        count += 1
                        switch result {
                        case .success(let club):
                            temp.append(club)
                        case .failure(let error):
                            AlertManager.shared.toggleAlertType(for: error)
                        }
                        
                        if count == bookmarkedClubCodes.count {
                            self.bookmarkedClubs = temp
                        }
                    }
                }
                
                
            }
            
        }
    }
    
    func getSubscriptionClubs(isLoggedIn: Bool) {
        if isLoggedIn {
            WKPennNetworkManager.instance.getAccessToken { token in
                guard let token = token else {
                    AlertManager.shared.toggleAlertType(for: NetworkingError.authenticationError)
                    return
                }
                
                ClubsAPI.instance.getSubscriptionClub(token: token) { result in
                    switch result {
                    case .success(let clubs):
                        self.subscribedClubs = clubs
                    case .failure(let error):
                        AlertManager.shared.toggleAlertType(for: error)
                    }
                }
            }
        }
    }
    
    func getEventsOfInterest(isLoggedIn: Bool) {
        if isLoggedIn {
            WKPennNetworkManager.instance.getAccessToken { token in
                guard let token = token else {
                    AlertManager.shared.toggleAlertType(for: NetworkingError.authenticationError)
                    return
                }
                
                EventsAPI.instance.getFavoriteClubEvents(token: token) { result in
                    switch result {
                    case .success(let events):
                        self.bookmarkedEvents = events
                    case .failure(let error):
                        AlertManager.shared.toggleAlertType(for: error)
                    }
                    self.isLoading = false
                }
            }
        } else {
            DispatchQueue.main.async {
                if (UserDefaults.standard.getBookmarkedClubCodes().count == 0) {
                    self.isLoading = false
                    self.bookmarkedEvents = []
                } else {
                    var temp: [Event] = []
                    var count = 0
                    
                    for code in UserDefaults.standard.getBookmarkedClubCodes() {
                        EventsAPI.instance.getClubEvent(for: code) { result in
                            count += 1
                            switch result {
                            case .success(let events):
                                temp.append(contentsOf: events)
                            case .failure(let error):
                                AlertManager.shared.toggleAlertType(for: error)
                            }

                            if (count == UserDefaults.standard.getBookmarkedClubCodes().count) {
                                temp.sort(by: {$0.startTime < $1.endTime})
                                self.bookmarkedEvents = temp
                                self.isLoading = false
                            }
                        }
                    }
                    
                    self.isLoading = false
                }
            }
        }
    }
    
}


