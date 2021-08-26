//
//  EventsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import WebKit

struct HomeView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var controllerModel: ControllerModel
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @State var pickerIndex = 0
    @State var previousIndex = 0
    
    let sectionTitle = ["My Events", "Bookmarked", "Subscribed"]
    
    var body: some View {
        VStack {
            Picker("Section", selection: $pickerIndex) {
                ForEach(0 ..< sectionTitle.count) {
                    Text(sectionTitle[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            ZStack {
                if homeViewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                
                if pickerIndex == 0 {
                    if (homeViewModel.bookmarkedEvents.count != 0) {
                        EventsView(events: homeViewModel.bookmarkedEvents)
                    } else if (!homeViewModel.isLoading) {
                        if (homeViewModel.bookmarkedClubs.count == 0) {
                            Text("You don't seem to have bookmarked any clubs. Bookmark clubs to see their events appear here!")
                                .padding()
                        } else {
                            Text("None of your clubs seems to have registered events on Penn Clubs.")
                                .padding()
                        }
                    }
                } else if pickerIndex == 1 {
                    if (!homeViewModel.isLoading && homeViewModel.bookmarkedClubs.count == 0) {
                        Text("You don't seem to have bookmarked any clubs. Bookmark clubs to see them appear here!")
                            .padding()
                    } else {
                        List(homeViewModel.bookmarkedClubs) { club in
                            NavigationLink(destination: ClubDetailView(for: club)) {
                                ClubRow(for: club)
                            }
                        }
                    }
                } else {
                    if (!homeViewModel.isLoading && homeViewModel.bookmarkedClubs.count == 0) {
                        Text("You don't seem to have subscribed to any clubs. Subscribe to clubs to see them appear here!")
                            .padding()
                    } else {
                        List(homeViewModel.subscribedClubs) { club in
                            NavigationLink(destination: ClubDetailView(for: club)) {
                                ClubRow(for: club)
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .onAppear {
            print("dlaksj")
            withAnimation {
                homeViewModel.fetchData(loginManager.isLoggedIn)
            }
        }
        .onChange(of: loginManager.isLoggedIn) { isLoggedIn in
            withAnimation {
                homeViewModel.fetchData(isLoggedIn)
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

