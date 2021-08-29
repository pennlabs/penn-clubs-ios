
//  DescriptionView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 21/7/2021.
//

import SwiftUI
import SwiftSoup
import Kingfisher

protocol MoveToMap {
    func moveToMap()
    func showFairPin()
}

struct DescriptionView: UIViewRepresentable {
    let descriptionString: String
    let frame: CGRect
    let clubCode: String
    let clubFair: ClubFair
    let isNavigationView: Bool
    let isOwner: Bool
    
    @Binding var presentFairPin: Bool
    @Binding var presentationMode: PresentationMode
    @EnvironmentObject var clubMapVM: ClubsMapViewModel
    @EnvironmentObject var controllerVM: ControllerModel
    @EnvironmentObject var clubDetailVM: ClubDetailViewModel
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: MoveToMap {
        var parent: DescriptionView
        
        init(_ parent: DescriptionView) {
            self.parent = parent
        }
        
        func moveToMap() {
            parent.clubMapVM.selectClub(of: parent.clubCode)
            parent.$presentationMode.wrappedValue.dismiss()
            parent.controllerVM.feature = .map
        }
        
        func showFairPin() {
            parent.presentFairPin.toggle()
        }
    }
    
    func makeUIView(context: Context) -> DescriptionUIView {
        return DescriptionUIView(descriptionString: descriptionString, moveToMapDelegate: context.coordinator, frame: frame, clubFair: clubFair, isOwner: isOwner, isNavigationView: isNavigationView)
    }

    func updateUIView(_ view: DescriptionUIView, context: Context) {
        if (isOwner) {
            if (clubDetailVM.clubFair!.isGenerated) {
                view.pin.image = UIImage(systemName: "exclamationmark.circle.fill")
                view.title.text = "Register Fair Location"
                view.descriptionLabel.text = "Your organization has not yet registered your in-person fair location. Tap to register."
                view.mapButton.backgroundColor = .red
            } else {
                view.pin.image = UIImage(systemName: "mappin.circle.fill")
                view.title.text = "Update Fair Location"
                view.descriptionLabel.text = "Your organization is registered to have a booth at \(clubDetailVM.clubFair!.start.monthDay()) from  \(Date.humanReadableDurationSameDay(from: clubDetailVM.clubFair!.start, to: clubDetailVM.clubFair!.end)). Tap to update."
                view.mapButton.backgroundColor = .greenDark
            }
        }
    }
}

class DescriptionUIView: UIScrollView, UITextViewDelegate {
    let descriptionString: String
    let moveToMapDelegate: MoveToMap
    let clubFair: ClubFair
    let isOwner: Bool
    let isNavigationView: Bool
     
    let mapButton = UIView()
    let pin = UIImageView()
    let title = UILabel()
    let descriptionLabel = UILabel()
    
    var viewContent = [UIView]()
    
    init(descriptionString: String, moveToMapDelegate: MoveToMap, frame: CGRect, clubFair: ClubFair, isOwner: Bool, isNavigationView: Bool) {
        self.descriptionString = descriptionString
        self.moveToMapDelegate = moveToMapDelegate
        self.clubFair = clubFair
        self.isOwner = isOwner
        self.isNavigationView = isNavigationView
        super.init(frame: frame)
        
        contentLayoutGuide.widthAnchor.constraint(equalToConstant: frame.width - 20).isActive = true
        self.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        
        if (isNavigationView && (!clubFair.isGenerated || isOwner)) {
            if (clubFair.end > Date() || isOwner) {
                
                mapButton.translatesAutoresizingMaskIntoConstraints = false
                mapButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
                
                
                
                if (clubFair.isGenerated) {
                    pin.image = UIImage(systemName: "exclamationmark.circle.fill")
                } else {
                    pin.image = UIImage(systemName: "mappin.circle.fill")
                }
                
            
                
                let arrow = UIImageView()
                arrow.image = UIImage(systemName: "chevron.right")
                
                
                
                title.font = .systemFont(ofSize: 25)
                
               

                mapButton.addSubview(pin)
                pin.translatesAutoresizingMaskIntoConstraints = false
                
                pin.leadingAnchor.constraint(equalToSystemSpacingAfter: mapButton.leadingAnchor, multiplier: 2.0).isActive = true
                pin.centerYAnchor.constraint(equalTo: mapButton.centerYAnchor).isActive = true
                pin.heightAnchor.constraint(equalToConstant: 40).isActive = true
                pin.widthAnchor.constraint(equalToConstant: 40).isActive = true
                pin.tintColor = .white
                
                mapButton.addSubview(arrow)
                arrow.translatesAutoresizingMaskIntoConstraints = false
                arrow.centerYAnchor.constraint(equalTo: mapButton.centerYAnchor).isActive = true
                arrow.heightAnchor.constraint(equalToConstant: 40).isActive = true
                arrow.widthAnchor.constraint(equalToConstant: 25).isActive = true
                arrow.trailingAnchor.constraint(equalTo: mapButton.trailingAnchor, constant: -20).isActive = true
                arrow.tintColor = .white
                
                mapButton.addSubview(title)
                title.translatesAutoresizingMaskIntoConstraints = false
                title.topAnchor.constraint(equalTo: mapButton.topAnchor, constant: 15).isActive = true
                title.leadingAnchor.constraint(equalToSystemSpacingAfter: pin.trailingAnchor, multiplier: 2.0).isActive = true
                title.font = .systemFont(ofSize: 20, weight: .semibold)
                title.textColor = .white
                
                mapButton.addSubview(descriptionLabel)
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
                descriptionLabel.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
                descriptionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: pin.trailingAnchor, multiplier: 2.0).isActive = true
                descriptionLabel.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -5).isActive = true
                descriptionLabel.bottomAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: -15).isActive = true
                descriptionLabel.numberOfLines = 0
                descriptionLabel.font = .systemFont(ofSize: 16, weight: .light)
                descriptionLabel.textColor = .white
                
                if (isOwner) {
                    if clubFair.isGenerated {
                        title.text = "Register Fair Location"
                        descriptionLabel.text = "Your organization has not yet registered your in-person fair location. Tap to register."
                        mapButton.backgroundColor = .red
                    } else {
                        title.text = "Update Fair Location"
                        descriptionLabel.text = "Your organization is registered to have a booth at \(clubFair.start.monthDay()) from  \(Date.humanReadableDurationSameDay(from: clubFair.start, to: clubFair.end)). Tap to update."
                        mapButton.backgroundColor = .greenDark
                    }

                    mapButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(togglePin)))
                } else {
                    mapButton.backgroundColor = UIColor.init(red: 1.0, green: 0.451, blue: 0.451, alpha: 1.0)
                    if (clubFair.isShown) {
                        title.text = "Find Booth Location"
                        descriptionLabel.text = "This organization has a booth at today's SAC Fair from " + Date.humanReadableDurationSameDay(from: clubFair.start, to: clubFair.end) + ". Tap to view their location."
                        mapButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToMap)))
                    } else {
                        title.text = "Find Booth Location"
                        descriptionLabel.text = "This organization has a booth at \(clubFair.start.monthDay()) from  \(Date.humanReadableDurationSameDay(from: clubFair.start, to: clubFair.end))."
                        arrow.isOpaque = true
                        arrow.layer.opacity = 0
                    }
                }
                
                mapButton.layer.cornerRadius = 18
                
                mapButton.layer.shadowColor = UIColor.black.cgColor
                mapButton.layer.shadowOpacity = 0.25
                mapButton.layer.shadowOffset = CGSize(width: 0, height: 4)
                mapButton.layer.shadowRadius = 4
                
                viewContent.append(mapButton)
            }
        }
        
        parseDescriptionString()
        loadViewContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parseDescriptionString() {
        guard let doc = try? SwiftSoup.parseBodyFragment(descriptionString) else { return }
        
        guard let body = doc.body() else { return }

        for element in body.children() {
            switch element.tagName() {
            case "p":
                _ = try? element.getElementsByTag("span").removeAttr("style")
                
                let html = (try? element.html()) ?? "Error. Please email jongmin@seas.upenn.edu to resolve"
                let label = UITextView()
                
                label.delegate = self
                label.dataDetectorTypes = [.link]
                label.isEditable = false
                label.isScrollEnabled = false
                
                DispatchQueue.main.async {
                    label.font = .systemFont(ofSize: 17)
                    label.setHTMLFromString(htmlText: html)

                    label.textColor = .label
                }

                label.backgroundColor = .none
                viewContent.append(label)
            case "iframe":
                if let src = try? element.attr("src"), let url = URL(string: src) {
                    let player = YouTubePlayerView()
                    player.loadVideoURL(url)
                    player.heightAnchor.constraint(equalToConstant: self.frame.width * 9/16).isActive = true
                    viewContent.append(player)
                }
            case "img":
                let imgView = UIImageView()

                if let src = try? element.attr("src"), let url = URL(string: src) {
                    imgView.kf.setImage(with: url, completionHandler:  { result in
                        if let value = try? result.get() {
                            let ratio = value.image.size.height / value.image.size.width
                            imgView.heightAnchor.constraint(equalToConstant: self.frame.width * ratio).isActive = true
                        }
                    })
                }

                viewContent.append(imgView)
            default:
                break
            }
        }
    }
        
    func loadViewContent() {
        for (n, content) in viewContent.enumerated() {
            addSubview(content);

            content.translatesAutoresizingMaskIntoConstraints = false

            content.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor).isActive = true
            content.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor).isActive = true
            
            if n == 0 {
                content.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0).isActive = true
            } else {
                content.topAnchor.constraint(equalToSystemSpacingBelow: viewContent[n - 1].bottomAnchor, multiplier: 0.1).isActive = true
            }

            if (n == viewContent.count - 1) {
                content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
        }
    }
    
    @objc func moveToMap() {
        moveToMapDelegate.moveToMap()
    }
    
    @objc func togglePin() {
        moveToMapDelegate.showFairPin()
    }
}
