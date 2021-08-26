//
//  EventDetailView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 24/8/2021.
//

import SwiftUI
import Kingfisher
import SwiftSoup
import EventKit
import EventKitUI

protocol PresentationModeProtocol {
    func dismiss()
}

struct EventDetailViewSwiftUI: UIViewControllerRepresentable {
    
    let event: Event

    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: PresentationModeProtocol {
        var parent: EventDetailViewSwiftUI
        
        init(_ parent: EventDetailViewSwiftUI) {
            self.parent = parent
        }
        
        func dismiss() {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = EventDetailUIView()
        vc.event = event
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ view: UIViewController, context: Context) { }
}

class EventDetailUIView: UIViewController, UITextViewDelegate {
    var event: Event!
    var delegate: PresentationModeProtocol!
    
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    var viewContent = [UIView]()
    let navBar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        setupNavBar()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true

        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalToSystemSpacingBelow: navBar.bottomAnchor, multiplier: 1.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        setupImage()
        setupTitle()
        parseDescriptionString()
        loadViewContent()
    }
    
    func setupNavBar() {
        view.addSubview(navBar)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20)
        
        let back = UIButton()
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: largeConfig)
        
        back.setImage(backImage, for: .normal)
        back.addTarget(self, action:#selector(dismissVC), for: .touchUpInside)
        
        navBar.addSubview(back)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        back.widthAnchor.constraint(equalToConstant: 40).isActive = true
        back.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let calendar = UIButton()
        let calendarImage = UIImage(systemName: "calendar.badge.plus", withConfiguration: largeConfig)
        calendar.setImage(calendarImage, for: .normal)
        calendar.addTarget(self, action: #selector(addEvent), for: .touchUpInside)

        navBar.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        calendar.widthAnchor.constraint(equalToConstant: 40).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func dismissVC() {
        delegate.dismiss()
    }
    
    @objc func addEvent() {
        let store = EKEventStore()

        //TODO refactor all of this
        store.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let eventVC = AddEventViewController(for: self.event)
//                    eventVC.clubEvent = self.event
                    eventVC.editViewDelegate = self
                    
                    self.present(eventVC, animated: true)
                } else if !granted {
                    let alert = UIAlertController(title: "Access Denied", message: "Please enable calendar access for PennClubs in your Settings", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Please try again later", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true)
                }
            }
        }
        
        
    }

    func setupImage() {
        scrollView.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true

        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

        if let imageURL = event.imageUrl {
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true

            imageView.kf.setImage(with: URL(string: imageURL))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
        } else {
            imageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }

    func setupTitle() {
        let time = UILabel()
        time.text = Date.humanReadableDuration(from: event.startTime, to: event.endTime)
        time.font = UIFont.preferredFont(forTextStyle: .subheadline)

        let timeTo = UILabel()
        timeTo.text = Date().humanReadableDistanceFrom(event.startTime)
        timeTo.font = UIFont.preferredFont(forTextStyle: .caption1)

        let clubName = UILabel()
        clubName.text = event.clubName
        clubName.font = .preferredFont(for: .headline, weight: .bold)
        clubName.numberOfLines = -1

        let eventName = UILabel()
        eventName.text = event.name
        eventName.font = .preferredFont(forTextStyle: .body)

        viewContent.append(time)
        viewContent.append(timeTo)
        viewContent.append(clubName)
        viewContent.append(eventName)
    }

    func parseDescriptionString() {
        guard let doc = try? SwiftSoup.parseBodyFragment(event.description) else { return }

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

                viewContent.append(label)
            case "iframe":
                if let src = try? element.attr("src"), let url = URL(string: src) {
                    let player = YouTubePlayerView()
                    player.loadVideoURL(url)
                    player.heightAnchor.constraint(equalToConstant: view.frame.width * 9/16).isActive = true
                    viewContent.append(player)
                }
            case "img":
                let imgView = UIImageView()

                if let src = try? element.attr("src"), let url = URL(string: src) {
                    imgView.kf.setImage(with: url, completionHandler:  { result in
                        if let value = try? result.get() {
                            let ratio = value.image.size.height / value.image.size.width
                            imgView.heightAnchor.constraint(equalToConstant: self.view.frame.width * ratio).isActive = true
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
            scrollView.addSubview(content);

            content.translatesAutoresizingMaskIntoConstraints = false

            if n <= 3 {
                content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 14).isActive = true
                content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -14).isActive = true
            } else {
                content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 10).isActive = true
                content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -10).isActive = true
            }


            if n == 0 {
                content.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 1.0).isActive = true
            } else if n <= 4 {
                content.topAnchor.constraint(equalToSystemSpacingBelow: viewContent[n - 1].bottomAnchor, multiplier: 0.5).isActive = true
            } else {
                content.topAnchor.constraint(equalToSystemSpacingBelow: viewContent[n - 1].bottomAnchor, multiplier: 0.1).isActive = true
            }

            if (n == viewContent.count - 1) {
                content.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            }
        }
    }
}

extension EventDetailUIView: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

struct EventDetailView: View {
    @Environment(\.presentationMode) var mode
    
    let event: Event
    
    init(for event: Event) {
        self.event = event
    }
    
    @State var calendarPresent = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    Button(action: {
                        mode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        calendarPresent.toggle()
                    }) {
                        Image(systemName: "calendar.badge.plus")
                    }
                    
                    Button(action: {
                        mode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .font(.system(size: 20, weight: .bold))
                .padding()
                
//                GeometryReader { reader in
//
//                    EventDetailViewSwiftUI(event: event, frame: reader.frame(in: .global))
//                }
            }
            .navigationBarHidden(true)
//
//            if calendarPresent {
//                EKEventWrapper(isShown: $calendarPresent)
//            }
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static let event: Event = Bundle.main.decode("testEvent.json", dateFormat: "yyyy-MM-dd'T'HH:mm:ssz")
    static var previews: some View {
        Group {
            EventDetailViewSwiftUI(event: event)
            EventDetailViewSwiftUI(event: event)
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}

extension UIFont {
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
