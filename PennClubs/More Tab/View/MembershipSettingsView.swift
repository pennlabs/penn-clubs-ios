//
//  MembershipSettingsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 18/7/2021.
//

import SwiftUI

struct MembershipSettingsView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var settingsVM: SettingsViewModel
    @State var clubMembership: ClubMembership
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Position")
                    Spacer()
                    Text(clubMembership.title)
                }
                
                HStack {
                    Text("Permissions")
                    Spacer()
                    Text(clubMembership.permissions)
                }
                
                Toggle("Active", isOn: $clubMembership.active)
            
                Toggle("Public", isOn: $clubMembership.isPublic)
            }
            
            Button("Leave", action: leaveClub)
                .foregroundColor(.red)
        }.navigationTitle(clubMembership.club.name)
        .onChange(of: clubMembership, perform: updateClubMembershipInfo)
    }
    
    func updateClubMembershipInfo(updatedClubMembership: ClubMembership) {
        print("updated")
    }
    
    func leaveClub() {
        settingsVM.leaveClub(id: clubMembership.club.id)
        presentationMode.wrappedValue.dismiss()
    }
}
