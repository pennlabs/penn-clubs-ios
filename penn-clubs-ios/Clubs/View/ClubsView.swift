//
//  ClubsView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI

struct ClubsView: View {
    
    let clubs: [ClubModel]
    
    init() {
        clubs = Bundle.main.decode("response.json", dateFormat: "yyyy-MM-dd")
    }
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            Spacer()
            List(clubs.filter({searchText.isEmpty ? true : $0.name.contains(searchText)})) { club in
                NavigationLink(destination: ClubDetailView(for: club)) {
                    ClubRow(for: club)
                }
            }
        }
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
