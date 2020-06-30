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
    var searchController : UISearchController = UISearchController(searchResultsController: nil)
    
    private let regionRadius : CLLocationDistance = 1000
    private var locationManager = CLLocationManager()
    private var info : PointsInfoToPass!
    
    private let doneButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.giveBorder(color: .black)
        return btn
    }()
    
    private let resetButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Reset", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.giveBorder(color: .black)
        return btn
    }()
    
    private let descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Tap on map to place a pin, you'll need 4 pins to set your location."
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        return lbl
    }()
    
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
        let locationSearchTable = LocationSearchTable()
        locationSearchTable.selectLocationDel = self
        self.searchController = UISearchController(searchResultsController: locationSearchTable)
        
        self.searchController.searchResultsUpdater = locationSearchTable
        let searchBar = self.searchController.searchBar
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        self.view.backgroundColor = .white
        self.mapView = MKMapView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 400))
        locationSearchTable.mapView = self.mapView
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
        self.mapView.showsUserLocation = true
        let stack = UIStackView()
        let stackHeight : CGFloat = 500
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(self.mapView)
        stack.addArrangedSubview(self.resetButton)
        self.view.addSubview(stack)
        self.view.addSubview(self.doneButton)
        stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        stack.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
        self.doneButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 10).isActive = true
        self.doneButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.doneButton.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        self.mapView.addGestureRecognizer(gestureRecognizer)
        self.mapView.delegate = self
        self.doneButton.isHidden = true
        self.doneButton.addTarget(self, action: #selector(self.done), for: .touchUpInside)
        self.resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
    }
    
    func centerLocationOnMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager = manager
        // Only called when variable have location data
    }
    
    @objc private func reset() {
        for annotation in self.mapView.annotations {
            self.mapView.removeAnnotation(annotation)
        }
        self.annotations = []
        self.doneButton.isHidden = true
        self.centerLocationOnMap(location: locationManager.location!)
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        guard self.annotations.count <= 3 else {
            return
        }
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        self.annotations.append(annotation)
        
        if self.annotations.count == 4 {
            self.doneButton.isHidden = false
        }
    }
    
    @objc private func done() {
        self.info._selectPointsDel.didSelectPoints(points: self.annotations)
        self.dismiss(animated: true) {}
    }
}

extension ChoosePointController : SelectLocationDel {
    func didSelectSearch(placemark: MKPlacemark) {
        guard placemark.location != nil else { return }
        self.centerLocationOnMap(location: placemark.location!)
    }
    
    
}
