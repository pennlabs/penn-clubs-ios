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
    @State var clubIsFavorite: Bool = false
    @State var clubIsSubscribed: Bool = false
    
    @EnvironmentObject var controllerModel: ControllerModel
    @EnvironmentObject var clubMapVM: ClubsMapViewModel
    @Environment(\.presentationMode) var mode
    
    @State var extendedClub: ExtendedClub? = nil
    @State var faqs: [QuestionAnswer]? = nil
    
    @State var isNavigationView: Bool = true
    
    init(for club: Club) {
        clubName = club.name
        clubCode = club.code
        clubImageURL = club.imageURL
        clubIsFavorite = club.isFavorite
        clubIsSubscribed = club.isSubscribe
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
        Group {
            if (isNavigationView) {
                HStack(spacing: 15) {
                    Button(action: {
                        mode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO
                        print("Edit button was tapped")
                    }) {
                        clubIsFavorite ? Image(systemName: "bookmark.fill") : Image(systemName: "bookmark")
                    }
                    
                    Button(action: {
                        print("Edit button was tapped")
                    }) {
                        clubIsSubscribed ? Image(systemName: "bell.fill") : Image(systemName: "bell")
                    }
                }
                .font(.system(size: 20, weight: .bold))
                .padding()
            }
            
            HStack(alignment: .center, spacing: 10) {
                if let imageURL = clubImageURL {
                    KFImage(URL(string: imageURL))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                }
                
                Text(clubName)
                    .font(.system(size: 25, weight: .bold))
                    .lineLimit(nil)

                Spacer()
            }.padding(.horizontal)
            
            
            Picker("Section", selection: $pickerIndex) {
                ForEach(0 ..< sectionTitle.count) {
                    Text(sectionTitle[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            Button(action: {
                clubMapVM.selectClub(of: clubCode)
                controllerModel.feature = .map
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                    mode.wrappedValue.dismiss()
                }
            }) {
                HStack {
                    Spacer()
                    
                    Text("Find it on Clubs Fair")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                    
                    Spacer()
                }
            }
            .background(
                Color.baseLabsBlue
//                RadialGradient(gradient: Gradient(colors: [.init(red: 0.85, green: 0.50, blue: 0.78),
//                                                           .init(red: 0.70, green: 0.31, blue: 0.58)]),
//                               center: .center,
//                               startRadius: 5,
//                               endRadius: 500)
            )
            .clipShape(Capsule())
            .padding([.top, .horizontal])
            
            GeometryReader { reader in
                if let extendedClub = extendedClub, let faqs = faqs {
                    if pickerIndex == 0 {
                        DescriptionView(descriptionString: extendedClub.description, frame: reader.frame(in: .global))
                    } else if pickerIndex == 1 {
                        OverviewView(for: extendedClub)
                    } else if pickerIndex == 2 {
                        FaqView(questionAnswers: faqs)
                    } else {
                        MembersView(for: extendedClub.members)
                    }
                } else {
                    ProgressView()
                        .position(x: reader.size.width / 2, y: reader.size.height / 2)
                        .onAppear(perform: fetchExtendedClubModel)
                }
            }
        }
        .navigationTitle(clubName)
        .navigationBarHidden(true)
    }
    
    func fetchExtendedClubModel() {
        ClubsAPI.instance.fetchClub(for: clubCode) { result in
            switch result {
            case .success(let extendedClub):
                self.extendedClub = extendedClub
            default:
                print(result)
            }
        }
        
        ClubsAPI.instance.fetchClubFaq(for: clubCode) { result in
            switch result {
            case .success(let faqs):
                self.faqs = faqs
            default:
                print(result)
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
