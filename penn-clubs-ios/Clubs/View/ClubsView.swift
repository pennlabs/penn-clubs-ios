//
//  ClubsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct ClubsView: View {
    @StateObject var clubResponseViewModel = ClubResponseViewModel()
    @State var searchText: String = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                SearchBar(text: $searchText.onChange(searchQueryChanged))
                InfiniteList(dataSource: clubResponseViewModel, row: ClubRow.init, detailView: ClubDetailView.init)
                Spacer()
            }.onAppear(perform: clubResponseViewModel.prepare)
            
            if clubResponseViewModel.isLoadingPage {
                ProgressView()
            }
            
            if !clubResponseViewModel.isLoadingPage && clubResponseViewModel.items.isEmpty {
                Text("No clubs found")
            }
        }
        
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


// Decodes .json data for SwiftUI Previews https://www.hackingwithswift.com/books/ios-swiftui/using-generics-to-load-any-kind-of-codable-data
extension Bundle {
    func decode<T: Codable>(_ file: String, dateFormat: String? = nil) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("unable to find data")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Data does not conform to desired structure")
        }
        
        return decoded
    }
}
