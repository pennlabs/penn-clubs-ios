//
//  OverviewView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 23/7/2021.
//

import SwiftUI
import SwiftSoup

struct OverviewView: View {
    let club: ExtendedClub
    
    init (for club: ExtendedClub) {
        self.club = club
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 7) {
                Group {
                    Text("Basic Info")
                        .font(.system(.title3))
                        .fontWeight(.bold)
                    
                    Label("\(club.membershipCount) Registered (\(club.sizeDescription))", systemImage: "person.fill")
                    
                    Label("\(club.acceptingMembersDescription)", systemImage: club.acceptingMembers ? "checkmark.circle" : "xmark.circle")
                    
                    Label(club.applicationRequiredDescription, systemImage: "square.and.pencil")
                    
                    Label(club.recuritingCycleDescription, systemImage: "clock")
                }
                
                Spacer().frame(height: 10)
                
                Group {
                    Text("Contact")
                        .font(.system(.title3))
                        .fontWeight(.bold)
                    
                    if (club.hasContacts) {
                        ForEach(Array(zip(club.contacts, club.contactsIcon)), id: \.1) { contact, icon in
                            if let contact = contact, let url = URL(string: contact) {
                                Label {
                                    Link(contact, destination: url)
                                        .lineLimit(1)
                                } icon: {
                                    Image(icon).resizable().frame(width: 20, height: 20)
                                }
                            }
                        }
                    }
                }
                
                Spacer().frame(height: 10)
                
                Group {
                    Text("How to Get Involved")
                        .font(.system(.title3))
                        .fontWeight(.bold)

                    Text((try? SwiftSoup.parse(club.getInvolvedDescription).text()) ?? "Error")
                }
            }.padding()
        }
    }
}
