//
//  ClubDetailView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import SwiftSoup
import Kingfisher


struct ClubDetailView: View {
    let clubName: String
    let clubCode: String
    let clubImageURL: String?
    let clubSubtitle: String
    let isNavigationView: Bool
    
    @StateObject var clubDetailVM = ClubDetailViewModel()

    @EnvironmentObject var controllerModel: ControllerModel
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var loginManager: LoginManager

    @Environment(\.presentationMode) var mode

    init(for club: Club) {
        clubName = club.name
        clubCode = club.code
        clubImageURL = club.imageURL
        clubSubtitle = club.subtitle
        isNavigationView = true
    }

    init(clubName: String, clubCode: String, clubImageURL: String?, subtitle: String) {
        self.clubName = clubName
        self.clubCode = clubCode
        self.clubImageURL = clubImageURL
        self.clubSubtitle = subtitle
        isNavigationView = false
    }

    private let sectionTitle = ["Description", "Overview", "FAQ", "Events"]

    @State private var mapLocationShown = false
    
    @State private var pickerIndex = 0
    
    var body: some View {
        VStack {
            if (isNavigationView) {
                HStack(spacing: 15) {
                    Button(action: {
                        mode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }

                    Spacer()

                    if clubDetailVM.extendedClub != nil {
                        Button(action: {
                            if loginManager.isLoggedIn {
                                clubDetailVM.toggleBookmark(clubCode: clubCode)
                            } else {
                                clubDetailVM.extendedClub!.isFavorite.toggle()
                                UserDefaults.standard.toggleBookmarkedClubCodes(clubCode: clubCode)
                            }
                        }) {
                            clubDetailVM.extendedClub!.isFavorite ? Image(systemName: "bookmark.fill") : Image(systemName: "bookmark")
                        }

                        Button(action: {
                            if loginManager.isLoggedIn {
                                clubDetailVM.toggleSubscribe(clubCode: clubCode)
                            } else {
                                loginManager.toggleAlert(handler: {})
                            }
                        }) {
                            clubDetailVM.extendedClub!.isSubscribe ? Image(systemName: "bell.fill") : Image(systemName: "bell")
                        }
                    }
                }
                .font(.system(size: 20))
                .padding()
                .frame(height: 40)
            }

            HStack(alignment: .center, spacing: 10) {
                if let imageURL = clubImageURL {
                    KFImage(URL(string: imageURL))
                        .loadImmediately()
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .onTapGesture(count: 5, perform: {
                            if (clubCode == "pennlabs" && isNavigationView) {
                                alertManager.toggleAlertType(for: Success.easterEgg)
                            }
                            controllerModel.feature = .home
                        })
                }

                Text(clubName)
                    .font(.system(size: 25, weight: .bold))
                    .lineLimit(nil)

                Spacer()
            }.padding()

            Picker("Section", selection: $pickerIndex) {
                ForEach(0 ..< sectionTitle.count) {
                    Text(sectionTitle[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.vertical, 5)

            GeometryReader { reader in
                if (clubDetailVM.isLoading) {
                    ProgressView()
                        .position(x: reader.size.width / 2, y: reader.size.height / 2)
                } else {
                    //necessary for animation to be enabled
                    Spacer()
                }
                
                if pickerIndex == 0 {
                    if let extendedClub = clubDetailVM.extendedClub, let clubFair = clubDetailVM.clubFair {
                        DescriptionView(descriptionString: extendedClub.description, frame: reader.frame(in: .global), clubCode: clubCode, clubFair: clubFair, isNavigationView: isNavigationView, isOwner: extendedClub.isOwner, presentFairPin: $mapLocationShown, presentationMode: mode)
                            .transition(.opacity)
                    }
                } else if pickerIndex == 1 {
                    if let extendedClub = clubDetailVM.extendedClub {
                        OverviewView(for: extendedClub)
                    }
                } else if pickerIndex == 2 {
                    if let faqs = clubDetailVM.faqs {
                        FaqView(questionAnswers: faqs)
                    }
                } else {
                    if let events = clubDetailVM.events {
                        EventsView(events: events)
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $mapLocationShown) {
            MapPinLocationView(clubCode: clubCode)
                .environmentObject(clubDetailVM)
        }
        .onAppear {
            clubDetailVM.fetchData(loginManager.isLoggedIn, clubCode: clubCode, name: clubName, imageUrl: clubImageURL, subtitle: clubSubtitle)
        }
        .environmentObject(clubDetailVM)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

// Hack to enable swipe from left while disabling navigation title
// TODO: find a more natural fix in future releases
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
