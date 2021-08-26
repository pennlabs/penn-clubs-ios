//
//  ClubFairMapView.swift
//  penn-clubs-ios
//
//  Created by CHOI Jongmin on 18/7/2021.
//

import SwiftUI
import MapKit
import Kingfisher

struct MapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    @Binding var clubFairLocations: [ClubFairLocation]
    @Binding var clubSelected: ClubAnnotation?
    
    let locationManager: CLLocationManager = CLLocationManager()

    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if control == view.rightCalloutAccessoryView {
                parent.clubSelected = view.annotation as? ClubAnnotation
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        
        mapView.register(ClubAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(LocationDataMapClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        for model in clubFairLocations {
            mapView.addAnnotation(ClubAnnotation(clubLocationModel: model))
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = context.coordinator
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
            mapView.showsUserLocation = true
        }
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if Set(view.annotations.compactMap { ($0 as? ClubAnnotation)?.id }) != Set(clubFairLocations.map{ $0.code }) {
            view.removeAnnotations(view.annotations)

            clubFairLocations.forEach { model in
                view.addAnnotation(ClubAnnotation(clubLocationModel: model))
            }
        }

        if view.region != region {
            view.setRegion(region, animated: true)
        }
    }
}


extension MKCoordinateRegion: Equatable {
    public static func ==(lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == rhs.center && lhs.span == rhs.span
    }
}

extension MKCoordinateSpan: Equatable {
    public static func ==(lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

