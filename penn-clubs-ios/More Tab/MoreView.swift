//
//  MoreView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct MoreView: View {
    
    @State var graduationYear = 2020
    @State var selection = ""
    
    init() {
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
            
            
            Section(header: Text("Eduction")) {
                Stepper(value: $graduationYear, in: 2020...2030, label: {
                    HStack {
                        
                        Text("Graduation Year: " + String(format: "%d", graduationYear))
                    }
                })
//                Picker(selection: $selection, label:
//                    Text("Picker Name")
//                    , content: {
//                        Text("Value 1").tag(0)
//                        Text("Value 2").tag(1)
//                        Text("Value 3").tag(2)
//                        Text("Value 4").tag(3)
//                    })
            }
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
