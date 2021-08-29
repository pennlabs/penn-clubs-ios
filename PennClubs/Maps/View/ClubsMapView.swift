//
//  ClubsMapView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import MapKit

struct ClubsMapView: View {
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var clubsMapVM : ClubsMapViewModel

    @State var isActionButtonExpanded = false
    @State var actionButtonState: FilterType? = nil
    @State var clubSelected: ClubAnnotation? = nil
    
    var body: some View {
        let showClub = Binding<Bool>(
            get: { clubSelected != nil },
            set: { if (!$0) {clubSelected = nil}}
        )
        
        return ZStack(alignment: .bottom) {
            MapView(clubSelected: $clubSelected)
                .edgesIgnoringSafeArea(.all)
                
            actionButton
            
            if (clubsMapVM.clubSelectionFilter || actionButtonState != nil) {
                clearSelectionButton
            }
        }
        .onAppear {
            
            clubsMapVM.fetchClubFairLocations()
        }
        .sheet(isPresented: showClub) {
            ClubDetailView(clubName: clubSelected!.title ?? "mising", clubCode: clubSelected!.id, clubImageURL: clubSelected!.imageUrl, subtitle: clubSelected!.callout)
                .padding(.top)
        }
    }
    
    var actionButton: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
              
                if isActionButtonExpanded {
                    ForEach(FilterType.allCases, id: \.hashValue) { filterType in
                        Button (action: {
                            withAnimation {
                                isActionButtonExpanded.toggle()
                                
                                if actionButtonState == filterType {
                                    actionButtonState = nil
                                    clubsMapVM.resetClubFairLocations()
                                } else {
                                    actionButtonState = filterType
                                    clubsMapVM.handleFilterType(for: filterType, isLoggedIn: loginManager.isLoggedIn)
                                }
                            }
                        }, label: {
                            Image(systemName: filterType.icon)
                                .font(.caption)
                                .padding()
                                .background(actionButtonState == filterType ? Color.uiBackground : Color.uiCardBackground)
                                .clipShape(Circle())
                        })
                    }
                }
                
                Button(action: {
                    withAnimation {
                        isActionButtonExpanded.toggle()
                    }
                }, label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                })
                .padding()
                .background(isActionButtonExpanded ? Color.uiBackground : Color.uiCardBackground)
                .foregroundColor(Color.accentColor)
                .font(.title)
                .clipShape(Circle())
                .padding()
                .frame(height: 90)
            }
        }
    }
    
    var clearSelectionButton: some View {
        VStack {
            Spacer()
            
            Button(action: {
                clubsMapVM.resetClubFairLocations()
                actionButtonState = nil
            }) {
                Text("Reset Filter")
                    .padding(.horizontal)
                    .padding(.vertical, 7)
                    .background(Color.uiBackground)
                    .clipShape(Capsule())
                    .padding()
            }
            .frame(height: 90)
        }
    }
}

struct ClubSearchButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
                .foregroundColor(.labelPrimary)
                .padding()

            Spacer()
        }.background(configuration.isPressed ? VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial)) : VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)))
    
    }
}
