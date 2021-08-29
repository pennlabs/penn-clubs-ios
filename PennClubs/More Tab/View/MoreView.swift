//
//  MoreView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct MoreView: View {
    
    @StateObject var settingsVM = SettingsViewModel()
  
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        Form {
            if loginManager.isLoggedIn {
                Section(header: Text("Profile"), footer: Text("If your information is incorrect, please send an email to contact@pennclubs.com detailing your issue.")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(settingsVM.profile.name)
                    }
                    HStack {
                        Text("Username")
                        Spacer()
                        Text(settingsVM.profile.username)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(settingsVM.profile.email)
                    }
                }
                
                Section(header: Text("Education")) {
                    Stepper(value: $settingsVM.profile.graduationYear, in: 2020...2030, label: {
                        Text("Graduation Year: " + String(format: "%d", settingsVM.profile.graduationYear))
                    })
                    MultiSelector(title: "Schools",
                                  label: Text("Schools"),
                                  options: settingsVM.schoolOptions,
                                  optionToString: { $0.name },
                                  selected: $settingsVM.profile.school)
                    MultiSelector(title: "Majors",
                                  label: Text("Majors"),
                                  options: settingsVM.majorOptions,
                                  optionToString: { $0.name },
                                  selected: $settingsVM.profile.major)
                }
                
                Button("Update Profile", action: settingsVM.updateProfile)
                    .disabled(settingsVM.profile == settingsVM.cached_profile)
                
//                Section(header: Text("Clubs")) {
//                    ForEach(settingsVM.clubMemberships, id: \.self.club.id) { clubMembership in
//                        NavigationLink(destination: MembershipSettingsView(settingsVM: settingsVM, clubMembership: clubMembership)) {
//                            Text(clubMembership.club.name)
//                        }
//                    }
//                }
            } else {
                Text("Please login to view your profile")
                    .multilineTextAlignment(.center)
            }
        }
    }

    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
