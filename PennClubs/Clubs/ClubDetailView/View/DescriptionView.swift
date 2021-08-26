
//  DescriptionView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 21/7/2021.
//

import SwiftUI
import SwiftSoup
import Kingfisher

struct DescriptionView: UIViewRepresentable {
    let descriptionString: String
    let frame: CGRect
    
    func makeUIView(context: Context) -> UIScrollView {
        return DescriptionUIView(descriptionString: descriptionString, frame: frame)
    }

    func updateUIView(_ view: UIScrollView, context: Context) { }
}

class DescriptionUIView: UIScrollView, UITextViewDelegate {
    let descriptionString: String
    var viewContent = [UIView]()
    
    init(descriptionString: String, frame: CGRect) {
        self.descriptionString = descriptionString
        super.init(frame: frame)
        
        contentLayoutGuide.widthAnchor.constraint(equalToConstant: frame.width - 20).isActive = true
        self.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        
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
                content.topAnchor.constraint(equalTo: topAnchor).isActive = true
            } else {
                content.topAnchor.constraint(equalToSystemSpacingBelow: viewContent[n - 1].bottomAnchor, multiplier: 0.1).isActive = true
            }

            if (n == viewContent.count - 1) {
                content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
        }
    }
}
