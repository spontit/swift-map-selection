//
//  ChoosePointController.swift
//  MapSelection
//
//  Created by Zhang Qiuhao on 6/25/20.
//  Copyright © 2020 Zhang Qiuhao. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class ChoosePointController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    var mapView : MKMapView!
    var annotations : [MKPointAnnotation] = []
    
    private let regionRadius : CLLocationDistance = 1000
    private var locationManager = CLLocationManager()
    private var info : PointsInfoToPass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    init(info: PointsInfoToPass!) {
        super.init(nibName: nil, bundle: nil)
        self.info = info
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.done))]
        self.mapView = MKMapView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 400))
        //var manager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        self.centerLocationOnMap(location: locationManager.location!)
        self.view.addSubview(self.mapView)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func centerLocationOnMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        // Only called when variable have location data
        //authorizelocationstates()
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {

        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        self.annotations.append(annotation)
    }
    
    @objc private func done() {
        self.info._selectPointsDel.didSelectPoints(points: self.annotations)
        self.dismiss(animated: true) {}
    }
}
