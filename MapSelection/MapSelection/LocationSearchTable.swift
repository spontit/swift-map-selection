//
//  LocationSearchTable.swift
//  MapSelection
//
//  Created by Zhang Qiuhao on 6/26/20.
//  Copyright © 2020 Zhang Qiuhao. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol SelectLocationDel {
    func didSelectSearch(placemark: MKPlacemark)
}

class LocationSearchTable : UITableViewController {
    
    var matchingItems : [MKMapItem] = []
    var mapView : MKMapView!
    var selectLocationDel : SelectLocationDel!
    
    let cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SearchLocationCell.self, forCellReuseIdentifier: self.cellId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count", self.matchingItems.count)
        return self.matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! SearchLocationCell
        
        let selectedItem = matchingItems[indexPath.row].placemark
//        cell.textLabel?.text = selectedItem.name
//
//        cell.detailTextLabel?.text = selectedItem.locality ?? ""
        cell.address = selectedItem
        print("cell", selectedItem.locality)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectLocationDel.didSelectSearch(placemark: self.matchingItems[indexPath.row].placemark)
        self.dismiss(animated: true) {}
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchLocationCell.HEIGHT
    }
    
    func getAddress(placemark: MKPlacemark) -> String {
        let locality = placemark.locality ?? ""
        let subLocality = placemark.subLocality ?? ""
        let thoroughfare = placemark.thoroughfare ?? ""
        let subThoroughfare = placemark.subThoroughfare ?? ""
        let country = placemark.country ?? ""
        print("add", locality, subLocality, thoroughfare, subThoroughfare, country)
        return locality + " " + subLocality + " " + thoroughfare + " " + subThoroughfare + " " + country
    }
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    
}
