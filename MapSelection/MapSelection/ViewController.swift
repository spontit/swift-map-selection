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

class ViewController: UIViewController {
    
    private var mapView : MKMapView!
    private let regionRadius : CLLocationDistance = 1000
    
    private var choosePointButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Choose Points", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUp()
    }
    
    private func setUp() {
        self.view.backgroundColor = .white
        self.mapView = MKMapView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 300))
        self.view.addSubview(mapView)
        self.view.addSubview(self.choosePointButton)
        self.choosePointButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20).isActive = true
        self.choosePointButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.choosePointButton.addTarget(self, action: #selector(self.choosePoint(_:)), for: .touchUpInside)
    }
    
    func centerLocationOnMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func choosePoint(_ sender: UIButton) {
        let mapVC = ChoosePointController(info: PointsInfoToPass(del: self, points: []))
        let navVC = UINavigationController(rootViewController: mapVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }

}

extension ViewController : SelectPointsDel {
    func didSelectPoints(points: [MKPointAnnotation]) {
        guard !points.isEmpty else { return }
        for point in points {
            self.mapView.addAnnotation(point)
        }
        self.mapView.setRegion(MKCoordinateRegion(center: points[0].coordinate, latitudinalMeters: self.regionRadius, longitudinalMeters: regionRadius), animated: true)
    }
}

