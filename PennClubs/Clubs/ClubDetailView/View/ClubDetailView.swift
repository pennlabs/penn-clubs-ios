//
//  ClubDetailView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 19/5/2021.
//

import SwiftUI
import SwiftSoup
import Kingfisher

//                            clubMapVM.selectClub(of: clubCode)
//                            controllerModel.feature = .map
//                            mode.wrappedValue.dismiss()

struct ClubDetailView: View {
    let clubName: String
    let clubCode: String
    let clubImageURL: String?
    let isNavigationView: Bool
    
    @State var isLoading = true
    @State var isBookmarked = false
    @State var isSubscribed = false
    
    @EnvironmentObject var controllerModel: ControllerModel
    @EnvironmentObject var clubMapVM: ClubsMapViewModel
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var loginManager: LoginManager
    
    @Environment(\.presentationMode) var mode
    
    @State var extendedClub: ExtendedClub? = nil
    @State var faqs: [QuestionAnswer]? = nil
    
    init(for club: Club) {
        clubName = club.name
        clubCode = club.code
        clubImageURL = club.imageURL
        isNavigationView = true
    }
    
    init(clubName: String, clubCode: String, clubImageURL: String?) {
        self.clubName = clubName
        self.clubCode = clubCode
        self.clubImageURL = clubImageURL
        isNavigationView = false
    }
    
    private let sectionTitle = ["Description", "Overview", "FAQ", "Members"]
    
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
                    
                    if extendedClub != nil {
                        Button(action: {
                            if loginManager.isLoggedIn {
                                print("TODO")
                            } else {
                                isBookmarked.toggle()
                                UserDefaults.standard.toggleBookmarkedClubCodes(clubCode: clubCode)
                            }
                        }) {
                            isBookmarked ? Image(systemName: "bookmark.fill") : Image(systemName: "bookmark")
                        }
                        
                        Button(action: {
                            if loginManager.isLoggedIn {
                                // do this only if success
                                print("TODO")
                            } else {
                                loginManager.toggleAlert(handler: {})
                            }
                        }) {
                            isSubscribed ? Image(systemName: "bell.fill") : Image(systemName: "bell")
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
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .onTapGesture(count: 5, perform: {
                            if (clubCode == "pennlabs" && isNavigationView) {
                                alertManager.toggleAlertType(for: Success.easterEgg)
                            }
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
                if let extendedClub = extendedClub, let faqs = faqs {
                    if pickerIndex == 0 {
                        DescriptionView(descriptionString: extendedClub.description, frame: reader.frame(in: .global))
                            .transition(.opacity)
                    } else if pickerIndex == 1 {
                        OverviewView(for: extendedClub)
                    } else if pickerIndex == 2 {
                        FaqView(questionAnswers: faqs)
                    } else {
                        MembersView(for: extendedClub.members)
                    }
                } else {
                    if (isLoading) {
                        ProgressView()
                            .position(x: reader.size.width / 2, y: reader.size.height / 2)
                    } else {
                        //necessary for animation to be enabled
                        Spacer()
                    }
                }
            }.edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            fetchExtendedClubModel()
        }
        .navigationBarHidden(true)
    }
    
    func fetchExtendedClubModel() {
        WKPennNetworkManager.instance.getAccessToken { token in
            ClubsAPI.instance.fetchExtendedClub(token: token, for: clubCode) { result in
                withAnimation {
                    print(result)
                    isLoading = false
                    switch result {
                    case .success(let extendedClub):
                        self.isBookmarked = extendedClub.isFavorite
                        self.isSubscribed = extendedClub.isSubscribe
                        
                        if (!loginManager.isLoggedIn && UserDefaults.standard.getBookmarkedClubCodes().contains(clubCode)) {
                            self.isBookmarked = true
                        }
                        
                        self.extendedClub = extendedClub
                    case .failure(let error):
                        AlertManager.shared.toggleAlertType(for: error)
                    }
                }
            }
            
            ClubsAPI.instance.fetchClubFaq(for: clubCode) { result in
                switch result {
                case .success(let faqs):
                    self.faqs = faqs
                case .failure(let error):
                    AlertManager.shared.toggleAlertType(for: error)
                }
            }
        }
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
