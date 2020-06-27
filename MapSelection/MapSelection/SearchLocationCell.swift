//
//  SearchLocationCell.swift
//  MapSelection
//
//  Created by Zhang Qiuhao on 6/26/20.
//  Copyright © 2020 Zhang Qiuhao. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchLocationCell : UITableViewCell {
    
    static let HEIGHT : CGFloat = 60
    
    var nameLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.text = " "
        return lbl
    }()
    
    var addressLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.text = " "
        return lbl
    }()
    
    var address : MKPlacemark! {
        didSet {
            self.nameLabel.text = address.name
            self.addressLabel.text = self.getAddress(placemark: address)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(self.nameLabel)
        stack.addArrangedSubview(self.addressLabel)
        self.contentView.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        stack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        stack.widthAnchor.constraint(equalToConstant: self.contentView.frame.width).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    private func getAddress(placemark: MKPlacemark) -> String {
        var locality = placemark.locality ?? ""
        if placemark.locality != nil {
            locality += ", "
        }
        var subLocality = placemark.subLocality ?? ""
        if placemark.subLocality != nil {
            subLocality += ", "
        }
        var thoroughfare = placemark.thoroughfare ?? ""
        if placemark.thoroughfare != nil {
            thoroughfare += ", "
        }
        var subThoroughfare = placemark.subThoroughfare ?? ""
        if placemark.subThoroughfare != nil {
            subThoroughfare += ", "
        }
        let country = placemark.country ?? ""

        print("add", locality, subLocality, thoroughfare, subThoroughfare, country)
        return locality + subLocality + thoroughfare + subThoroughfare + country
    }
    
}
