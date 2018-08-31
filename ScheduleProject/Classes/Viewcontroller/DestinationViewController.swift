//
//  DestinationViewController.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/21.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var search: AMapSearchAPI!
    var searchResults: [AMapPOI]? {
        didSet {
            searchResultTableView.reloadData()
        }
    }
    
    lazy var locationManager = AMapLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearch()
        initMapView()
        initTableView()
        configLocationManager()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func initMapView() {
        mapView.delegate = self
        mapView.touchPOIEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
    }

    func initTableView() {
        
    }
    
    //MARK: - Action Handle
    
    func configLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    func annotationForPoi(touchPoi:MATouchPoi?) -> MAPointAnnotation! {
        if (touchPoi == nil)
        {
            return nil;
        }
        
        let annotation = MAPointAnnotation.init()
        
        annotation.coordinate = touchPoi!.coordinate
        annotation.title      = touchPoi!.name
        
        return annotation;
    }
    
    //MARK: - mapview delegate
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.isDraggable = false
            annotationView!.pinColor = MAPinAnnotationColor.red
            
            return annotationView!
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didTouchPois pois: [Any]!) {
        if (pois.count == 0)
        {
            return;
        }
        
        let poi = pois.first
        
        let annotation = self.annotationForPoi(touchPoi: (poi as! MATouchPoi?))
        
        /* Remove prior annotation. */
//        self.mapView.removeAnnotation(self.poiAnnotation)
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        
//        self.poiAnnotation = annotation;
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation {
            return
        }
        if userLocation.location.horizontalAccuracy < 0 {
            return
        }
        
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        guard let subtitle = view.annotation.subtitle else { return  }
        let locationInfo = LocationInfo(name: view.annotation.title ?? "", location: view.annotation.coordinate , address: subtitle ?? "", city: "")
        performSegue(withIdentifier: "destinationDetail", sender: locationInfo.eventInfo)
        
    }

    
    //MARK:- event handling
    func touchPOIEanbledAction(sender: UISwitch!) {
        self.mapView.touchPOIEnabled = sender.isOn
    }
    
    func searchPOI(withKeyword keyword: String?) {
        
        if keyword == nil || keyword! == "" {
            return
        }
        let userLocation = mapView.userLocation.coordinate
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.requireExtension = true
    
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(userLocation.latitude), longitude: CGFloat(userLocation.longitude))
        search.aMapPOIKeywordsSearch(request)
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        if let location = location {
            SingleEvents.shared.userLocation = location.coordinate
            let annotation = MAPointAnnotation()
            annotation.coordinate = location.coordinate
            if let regeocode = reGeocode {
                annotation.title = regeocode.formattedAddress
                annotation.subtitle = "\(regeocode.citycode!)-\(regeocode.adcode!)-\(location.horizontalAccuracy)m"
            }
            else {
                annotation.title = String(format: "lat:%.6f;lon:%.6f;", arguments: [location.coordinate.latitude, location.coordinate.longitude])
                annotation.subtitle = "accuracy:\(location.horizontalAccuracy)m"
            }
        }
    }
}
extension DestinationViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "demoCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        cell?.selectionStyle = .none
        cell?.textLabel?.text = searchResults?[indexPath.row].name ?? ""
        cell?.detailTextLabel?.text = searchResults?[indexPath.row].address ?? ""
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults?[indexPath.row]
        performSegue(withIdentifier: "destinationDetail", sender: searchResult?.locationInfo.eventInfo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "destinationDetail" {
            let vc = segue.destination as? DestinationDetailViewController
            vc?.detailInfo = sender as? EventInfo
        }
    }
}

extension DestinationViewController {
    //MARK:- UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchPOI(withKeyword: searchBar.text)
    }
}

extension DestinationViewController {
    //MARK: - AMapSearchDelegate
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        mapView.removeAnnotations(mapView.annotations)
        if response.count == 0 {
            return
        }
        searchResults = response.pois
        
        var annos = Array<MAPointAnnotation>()
        for aPOI in response.pois {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = aPOI.name
            anno.subtitle = aPOI.address
            annos.append(anno)
        }
        
        mapView.addAnnotations(annos)
        mapView.showAnnotations(annos, animated: false)
    }
}
