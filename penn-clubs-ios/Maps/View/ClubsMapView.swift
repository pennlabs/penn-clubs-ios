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
    
    @State var searchString = ""

    @State var isActionButtonExpanded = false
    @State var actionButtonState: FilterType? = nil
    @State var clubSelected: ClubAnnotation? = nil
    
    var body: some View {
        let showClub = Binding<Bool>(
            get: { clubSelected != nil },
            set: { if (!$0) {clubSelected = nil}}
        )
        
        return ZStack(alignment: .bottom) {
            MapView(region: $clubsMapVM.region, clubFairLocations: $clubsMapVM.clubFairLocations, clubSelected: $clubSelected)
                .edgesIgnoringSafeArea(.all)
    
            actionButton
        }
        .sheet(isPresented: showClub) {
            ClubDetailView(clubName: clubSelected!.title ?? "mising", clubCode: clubSelected!.id, clubImageURL: clubSelected!.imageUrl)
        }
    }
    
    var searchBar: some View {
        VStack {
            SearchBar(text: $searchString, cancelButtonExists: false) { VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)) }
                .padding(.vertical, 10)
                .onChange(of: searchString, perform: clubsMapVM.searchClub)
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(clubsMapVM.searchClubName, id: \.self) { name in
                    Button(name) {
                        withAnimation {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            clubsMapVM.focusOnClub(name: name)
                            searchString = ""
                        }
                    }
                    .buttonStyle(ClubSearchButtonStyle())
                    .frame(minHeight: 30)
                    
                    if let lastClubName = clubsMapVM.searchClubName.last, lastClubName != name {
                        Divider().padding(.leading)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)

            Spacer()
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
                                if actionButtonState == filterType {
                                    searchString = ""
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
                    Image(systemName: "plus")
                })
                .padding()
                .background(isActionButtonExpanded ? Color.uiBackground : Color.uiCardBackground)
                .foregroundColor(Color.accentColor)
                .font(.title)
                .clipShape(Circle())
                .padding()
            }
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
