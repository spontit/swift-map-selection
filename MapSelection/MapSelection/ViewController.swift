//
//  ViewController.swift
//  MapSelection
//
//  Created by Zhang Qiuhao on 6/25/20.
//  Copyright © 2020 Zhang Qiuhao. All rights reserved.
//

import UIKit
import MapKit

protocol SelectPointsDel {
    func didSelectPoints(points: [MKPointAnnotation])
}

struct PointsInfoToPass {
    var _selectPointsDel : SelectPointsDel!
    var _pointsSelected : [MKPointAnnotation]?
    
    init(del: SelectPointsDel, points: [MKPointAnnotation]?) {
        self._selectPointsDel = del
        self._pointsSelected = points
    }
}

class ViewController: UIViewController, MKMapViewDelegate {
    
    private var mapView : MKMapView!
    private let regionRadius : CLLocationDistance = 1000
    private var pointsSelected : [MKPointAnnotation] = []
    
    private var choosePointButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Choose Points", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.giveBorder(color: .black)
        return btn
    }()
    
    private let descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Press the button to set your location."
        lbl.font = UIFont.systemFont(ofSize: 28)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUp()
    }
    
    private func setUp() {
        self.view.backgroundColor = .white
        
        self.mapView = MKMapView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 300))
        self.mapView.delegate = self
        let stack = UIStackView()
        let stackHeight : CGFloat = 500
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.addArrangedSubview(self.descriptionLabel)
        stack.addArrangedSubview(self.mapView)
        stack.addArrangedSubview(self.choosePointButton)
        self.view.addSubview(stack)
        //stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        stack.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
        self.choosePointButton.addTarget(self, action: #selector(self.choosePoint(_:)), for: .touchUpInside)
    }
    
    func centerLocationOnMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay .isKind(of: MKPolygon.self) {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor(white: 0.5, alpha: 0.5)
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    @objc func choosePoint(_ sender: UIButton) {
        let mapVC = ChoosePointController(info: PointsInfoToPass(del: self, points: []))
        let navVC = UINavigationController(rootViewController: mapVC)
        navVC.modalPresentationStyle = .fullScreen
        self.mapView.removeAnnotations(self.pointsSelected)
        self.present(navVC, animated: true)
    }

}

extension ViewController : SelectPointsDel {
    func didSelectPoints(points: [MKPointAnnotation]) {
        guard !points.isEmpty else { return }
        self.pointsSelected = points
        var coordinates = [CLLocationCoordinate2D]()
        for point in points {
            self.mapView.addAnnotation(point)
            coordinates.append(point.coordinate)
        }
        self.mapView.setRegion(MKCoordinateRegion(center: points[0].coordinate, latitudinalMeters: self.regionRadius, longitudinalMeters: regionRadius), animated: true)
        let polygon = MKPolygon(coordinates: &coordinates, count: coordinates.count)
        self.mapView.addOverlay(polygon)
        
    }
}

extension UIView {

func removeBorder() {
    self.layer.borderWidth = 0
}

func giveBorder(color: UIColor) {
    self.layer.borderWidth = 1
    self.layer.borderColor = color.cgColor
}
}
