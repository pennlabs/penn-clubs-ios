//
//  ClubsMapView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import MapKit

struct ClubsMapView: View {
    @State var region = MKCoordinateRegion(center: .init(latitude: 39.951830, longitude: -75.194855), latitudinalMeters: 600, longitudinalMeters: 600)
    
//    @GestureState var dragState: DragState = .inactive
//    let clubs: [ClubModel]
//
//    init() {
//        clubs = Bundle.main.decode("response-copy.json", dateFormat: "yyyy-MM-dd")
//    }
    
    @State var searchString = ""
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottom) {
//                Map(coordinateRegion: $region)
//                    .ignoresSafeArea()
                
//                modal(reader: reader)
//                    .frame(height: reader.size.height * 0.5)
                Text("something")
            }
        }.onAppear(perform: {
//            UITableViewCell.appearance().backgroundColor = .clear
//            UITableView.appearance().backgroundColor = .clear
        }).onDisappear(perform: {
//            UITableViewCell.appearance().backgroundColor = .systemBackground
//            UITableView.appearance().backgroundColor = .systemBackground
        })
    }
    
    func modal(reader: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                .cornerRadius(20, corners: [.topLeft, .topRight])
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(Color(UIColor.lightGray))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .frame(width: reader.size.width * 0.2, height: 6)
                    .padding(.vertical, 10)
                
                SearchBar(text: $searchString)
                
                Spacer()
                
//                List {
//                    ForEach(clubs) { club in
//                        Text(club.name)
//                    }
//                    .listRowBackground(Color.clear)
//                }.disabled(true)
            }
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct ClubsMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TabView {
                ClubsMapView()
            }
        }
        .preferredColorScheme(.light)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
