//
//  LocationDataMapClusterView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 20/7/2021.
//

import MapKit

final class LocationDataMapClusterView: MKAnnotationView {
    let width: CGFloat = 40
    let height: CGFloat = 50
    let border: CGFloat = 2

    let pin = UIView()
    let circle = UIView()
    let countLabel = UILabel()
    
    override var annotation: MKAnnotation? {
        willSet {
            if let annotation = newValue as? MKClusterAnnotation {
                countLabel.text = annotation.memberAnnotations.count < 100 ? "\(annotation.memberAnnotations.count)" : "99+"
            }
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        displayPriority = .required
        collisionMode = .circle

        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupLabel()
        setupCircle()
        setupTriangle()
        
        addSubview(pin)
        pin.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        pin.addSubview(countLabel)
        
        countLabel.textColor = .white
        countLabel.centerXAnchor.constraint(equalTo: pin.centerXAnchor).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: pin.centerYAnchor, constant: -5).isActive = true
    }
    
    func setupCircle() {
        circle.backgroundColor = .baseLabsBlue
        circle.translatesAutoresizingMaskIntoConstraints = false
        pin.insertSubview(circle, belowSubview: countLabel)
        circle.leadingAnchor.constraint(equalTo: pin.leadingAnchor).isActive = true
        circle.trailingAnchor.constraint(equalTo: pin.trailingAnchor).isActive = true
        circle.topAnchor.constraint(equalTo: pin.topAnchor).isActive = true
        circle.heightAnchor.constraint(equalToConstant: width).isActive = true
        circle.layer.cornerRadius = width/2
        circle.layer.borderWidth = 3
        circle.layer.borderColor = UIColor.white.cgColor
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
