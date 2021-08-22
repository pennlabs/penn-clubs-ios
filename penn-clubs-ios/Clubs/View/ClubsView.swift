//
//  ClubsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct ClubsView: View {
    @StateObject var clubResponseViewModel = ClubResponseViewModel()
    @State var searchText: String = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                SearchBar(text: $searchText, cancelButtonExists: true) { Color.grey6 }
                InfiniteList(dataSource: clubResponseViewModel, row: ClubRow.init, detailView: ClubDetailView.init)
                Spacer()
            }
            
            if clubResponseViewModel.isLoadingPage {
                ProgressView()
            }
            
            if !clubResponseViewModel.isLoadingPage && clubResponseViewModel.items.isEmpty {
                Text("No clubs found")
            }
        }.onChange(of: searchText, perform: searchQueryChanged)
        
    }
    
    private func searchQueryChanged(to value: String) {
        clubResponseViewModel.searchQuery = value
        clubResponseViewModel.reset()
    }
}

struct ClubsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClubsView()
        }
    }
}
