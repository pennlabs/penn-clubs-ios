//
//  MoreView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct MoreView: View {
    
//    @State var profile: ProfileModel
    
    init() {
//        profile = ProfileNetworkManager.get
        
        // fetch info from user and populate information
    }
    
    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Jong-Min Choi")
                }
                HStack {
                    Text("Username")
                    Spacer()
                    Text("jongmin")
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text("jongmin@sas.upenn.edu")
                }
            }
            
//
//            Section(header: Text("Eduction")) {
//                Stepper(value: $graduationYear, in: 2020...2030, label: {
//                    HStack {
//
//                        Text("Graduation Year: " + String(format: "%d", graduationYear))
//                    }
//                })
////
//            }
            
//            Section(header: Text("Education")) {
//                Picker("My Picker", selection: $selection) {
//                   Text("Banana 🍌🍌")
//                   Text("Apple 🍎🍎")
//                   Text("Peach 🍑🍑")
//               }
//                .pickerStyle(InlinePickerStyle())
//            }
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
