//
//  InfiniteList.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 16/7/2021.
//

import SwiftUI
import Alamofire
import Combine

struct InfiniteList<Data, RowContent, Content>: View
    where Data: InfiniteListData, RowContent: View, Content: View{
    
    @ObservedObject var dataSource: InfiniteListDataSource<Data>
    let row: (Data.Item) -> RowContent
    let detailView: (Data.Item) -> Content

    init(dataSource: InfiniteListDataSource<Data>, @ViewBuilder row: @escaping (Data.Item) -> RowContent,
         @ViewBuilder detailView: @escaping (Data.Item) -> Content) {
        self.dataSource = dataSource
        self.row = row
        self.detailView = detailView
    }
    
    var body: some View {
        List {
            ForEach(dataSource.items) { item in
                NavigationLink(destination: detailView(item)) {
                    row(item)
                }
                .onAppear {
                    dataSource.loadMoreContentIfNeeded(currentItem: item)
                }
            }
        }
    }
}

class InfiniteListDataSource<Data>: ObservableObject where Data: InfiniteListData {
    @Published var items = [Data.Item]()
    @Published var isLoadingPage = false
    
    private var currentPage = 1
    private var canLoadMorePages = true
    private var searchQuery = ""
    
    init() {
        loadMoreContent()
    }
    
    func reset() {
        items = [Data.Item]()
        currentPage = 1
        isLoadingPage = false
        canLoadMorePages = true
        loadMoreContent()
    }
    
    // Override this function to return new url
    func getUrl(pageNumber: Int) -> String {
        return ""
    }

    func loadMoreContentIfNeeded(currentItem item: Data.Item?) {
        guard let item = item else {
            loadMoreContent()
            return
        }

        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }

        isLoadingPage = true

        WKPennNetworkManager.instance.getAccessToken { token in
            let url = URL(string: self.getUrl(pageNumber: self.currentPage))!
            
            let urlRequest: URLRequest
            
            if let token = token {
                urlRequest = URLRequest(url: url, accessToken: token)
            } else {
                urlRequest = URLRequest(url: url)
            }
            
            let decoder = JSONDecoder()
        
            if let dateFormat = Data.dateDecodingStrategy {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormat
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
            } else {
                decoder.dateDecodingStrategy = .iso8601
            }
            
            URLSession.shared.dataTaskPublisher(for: urlRequest)
                .map(\.data)
                .decode(type: Data.self, decoder: decoder)
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { response in
                    self.canLoadMorePages = response.hasMorePages
                    self.isLoadingPage = false
                    self.currentPage += 1
                })
                .map({ response in
                    return self.items + response.items
                })
                .catch({ _ in Just(self.items) })
                .assign(to: &self.$items)
        }
        
    }
}

protocol InfiniteListData: Codable {
    associatedtype Item: Identifiable
    static var dateDecodingStrategy: String? { get set }
    
    var hasMorePages: Bool { get }
    var items: [Item] { get }
}
