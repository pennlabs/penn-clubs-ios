//
//  MapPinLocationView.swift
//  PennClubs
//
//  Created by CHOI Jongmin on 28/8/2021.
//

import SwiftUI
import MapKit

struct MapPinLocationView: View {
    let clubCode: String
    
    @Environment(\.presentationMode) var mode
    @State private var region = MKCoordinateRegion(center: .init(latitude: 39.951830, longitude: -75.194855), latitudinalMeters: 600, longitudinalMeters: 600)
    
    @State private var alertShown = false
    
    @EnvironmentObject var clubDetailVM: ClubDetailViewModel
    
    var body: some View {
        return NavigationView {
            VStack {
                DatePicker(
                    "Start Time",
                    selection:  Binding($clubDetailVM.clubFair)!.start,
                    displayedComponents: [.date, .hourAndMinute]
                )
                
                DatePicker(
                    "End Time",
                    selection: Binding($clubDetailVM.clubFair)!.end,
                    displayedComponents: [.date, .hourAndMinute]
                )
                
                
                ZStack {
                    Map(coordinateRegion: $region, annotationItems: [clubDetailVM.clubFair!]) {
                        MapPin(coordinate: $0.coordinate)
                    }
                    
                    Circle()
                        .fill(Color.blue)
                        .opacity(0.3)
                        .frame(width: 22, height: 22)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                clubDetailVM.clubFair!.coordinate = region.center
                            }) {
                                Image(systemName: "pin")
                            }
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                            .padding(.bottom)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Button(clubDetailVM.clubFair!.isGenerated ? "Register" : "Update") {
                    if (clubDetailVM.clubFair!.end < clubDetailVM.clubFair!.start || clubDetailVM.clubFair!.start.day != clubDetailVM.clubFair!.end.day) {
                        alertShown.toggle()
                    } else {
                        mode.wrappedValue.dismiss()
                        clubDetailVM.registerClubFair()
                    }
                }
            }
            .alert(isPresented: $alertShown) {
                Alert(title: Text("Inavlid Request"), message: Text("Invalid date/time range. End time must be greater than start time; in-person fair event must start and end on the same day."), dismissButton: .default(Text("OK")))
            }
            .padding()
            .navigationTitle("Register Club Booth")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
