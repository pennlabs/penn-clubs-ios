//
//  ClubAnnotationView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 20/7/2021.
//

import MapKit

class ClubAnnotationView: MKAnnotationView {
    
    let width: CGFloat = 40
    let height: CGFloat = 50
    let border: CGFloat = 2

    let pin = UIView()
    let imgView = UIImageView()
    let circle = UIView()
    let callOutLabel = UILabel()
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "clusteringIdentifier"
            if let clubAnnotation = newValue as? ClubAnnotation {
                if let imageUrl = clubAnnotation.imageUrl {
                    imgView.kf.setImage(with: URL(string: imageUrl))
                } else {
                    imgView.image = nil
                }
                
                callOutLabel.text = clubAnnotation.callout
            }
        }
    }
    
    // MARK: Initialization
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        bounds = CGRect(x: 0, y: 0, width: width, height: height)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)

        canShowCallout = true
        let calloutButton = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = calloutButton
        
        callOutLabel.numberOfLines = 3
        callOutLabel.font = .systemFont(ofSize: UIFont.smallSystemFontSize)
        callOutLabel.lineBreakMode = .byTruncatingTail
        detailCalloutAccessoryView = callOutLabel
        
        clusteringIdentifier = "clusteringIdentifier"
        
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        setupImgView()
        setupCircle()
        setupTriangle()
        
        addSubview(pin)
        pin.frame = bounds
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImgView() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        pin.addSubview(imgView)
    
        imgView.leadingAnchor.constraint(equalTo: pin.leadingAnchor, constant: border).isActive = true
        imgView.trailingAnchor.constraint(equalTo: pin.trailingAnchor, constant: -border).isActive = true
        imgView.topAnchor.constraint(equalTo: pin.topAnchor, constant: border).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: width - 2 * border).isActive = true
        imgView.layer.cornerRadius = width/2
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
    }
    
    func setupCircle() {
        circle.backgroundColor = .white
        circle.translatesAutoresizingMaskIntoConstraints = false
        pin.insertSubview(circle, belowSubview: imgView)
        circle.leadingAnchor.constraint(equalTo: pin.leadingAnchor).isActive = true
        circle.trailingAnchor.constraint(equalTo: pin.trailingAnchor).isActive = true
        circle.topAnchor.constraint(equalTo: pin.topAnchor).isActive = true
        circle.heightAnchor.constraint(equalToConstant: width).isActive = true
        circle.layer.cornerRadius = width/2
    }
    
    func setupTriangle() {
        let heightTest: CGFloat = 21
        let widthTest: CGFloat = 35
        let triangle = TriangleView(frame: CGRect(x: 0, y: 0, width: widthTest, height: heightTest), color: UIColor.white, rotate: 90)
        triangle.translatesAutoresizingMaskIntoConstraints = false
        triangle.backgroundColor = .clear
        pin.insertSubview(triangle, belowSubview: circle)
        triangle.centerXAnchor.constraint(equalTo: pin.centerXAnchor).isActive = true
        triangle.bottomAnchor.constraint(equalTo: pin.bottomAnchor).isActive = true
        triangle.heightAnchor.constraint(equalToConstant: heightTest).isActive = true
        triangle.widthAnchor.constraint(equalToConstant: widthTest).isActive = true
    }
}


class TriangleView : UIView {
    let color: UIColor
    let angle: CGFloat

    init(frame: CGRect, color: UIColor, rotate: CGFloat) {
//        super.init(frame: frame)
//        self.frame = frame
        self.color = color
        self.angle = rotate
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }

    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.closePath()

        context.setFillColor(color.cgColor)
        context.fillPath()
    }
}
