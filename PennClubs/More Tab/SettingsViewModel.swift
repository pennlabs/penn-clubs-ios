//
//  SettingsViewModel.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 17/7/2021.
//

import Foundation
import SwiftUI

class HapticsEnabled {
    let generator = UINotificationFeedbackGenerator()
    
    func successHaptic() {
        generator.notificationOccurred(.success)
    }
}

class SettingsViewModel: ObservableObject {
    
    @Published var profile: Profile = Storage.retrieveFromCache(Profile.directory, as: Profile.self) ?? Profile.defaultModel
    var cached_profile: Profile = Storage.retrieveFromCache(Profile.directory, as: Profile.self) ?? Profile.defaultModel
    
    var majorOptions = [Major]()
    var schoolOptions = [School]()
    
    @Published var clubMemberships = Storage.retrieveFromCache(ClubMembership.directory, as: [ClubMembership].self) ?? [ClubMembership]()
    
    func fetchData(_ isLoggedIn: Bool) {
        if isLoggedIn {
            fetchProfile()
            fetchMembership()
            
            fetchMajors()
            fetchSchools()
        }
    }
    
    func fetchMembership() {
        SettingsAPI.instance.fetchMembership { result in
            switch result {
            case .success(let clubMemberships):
                self.clubMemberships = clubMemberships
                Storage.storeToCache(clubMemberships, as: ClubMembership.directory)
            case .failure(.authenticationError):
                self.clubMemberships = [ClubMembership]()
            case .failure(let error):
                AlertManager.shared.toggleAlertType(for: error)
            }
        }
    }
    
    func fetchProfile() {
        SettingsAPI.instance.fetchSettingsProfile { result in
            switch result {
            case .success(let profile):
                Storage.storeToCache(profile, as: Profile.directory)
                self.profile = profile
                self.cached_profile = profile
            case .failure(.authenticationError):
                self.profile = Profile.defaultModel
                self.cached_profile = Profile.defaultModel
            case .failure(let error):
                AlertManager.shared.toggleAlertType(for: error)
            }
        }
    }
    
    func fetchMajors() {
        SettingsAPI.instance.fetchMajors { result in
            print(result)
            switch result {
            case .success(let majors):
                self.majorOptions = majors
            case .failure(let error):
                AlertManager.shared.toggleAlertType(for: error)
            }
        }
    }
     
    func fetchSchools() {
        DispatchQueue.main.async {
            SettingsAPI.instance.fetchSchools { result in
                print(result)
                switch result {
                case .success(let schools):
                    self.schoolOptions = schools
                case .failure(let error):
                    AlertManager.shared.toggleAlertType(for: error)
                }
            }
        }
    }

    func updateProfile() {
        DispatchQueue.main.async {
            SettingsAPI.instance.updateProfile(for: self.profile) { result in
                switch result {
                case .success(let updatedProfile):
                    self.profile = updatedProfile
                    Storage.storeToCache(updatedProfile, as: Profile.directory)
                case .failure(let error):
                    AlertManager.shared.toggleAlertType(for: error)
                }
            }
        }
    }
    
    func profileHasChanged() -> Bool {
        return cached_profile != profile
    }
    
    func leaveClub(id: String) {
        clubMemberships.removeAll(where: {
            $0.club.id == id
        })
    }
}
