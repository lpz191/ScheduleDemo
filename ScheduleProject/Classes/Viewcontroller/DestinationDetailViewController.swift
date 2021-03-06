//
//  DestinationDetailViewController.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/23.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class DestinationDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    
    @IBOutlet weak var arrangeView: UIView!
    @IBOutlet weak var storedView: UIView!
    
    
    var myContext: NSObject!
    
    var detailInfo: EventInfo!
    
    var poiAnnotation: MAPointAnnotation!

    var observation: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initMapView()
        
        observation = detailInfo.observe(\.duration) { (eventInfo, _) in
            self.ETALabel.text = eventInfo.eta
            self.milesLabel.text = eventInfo.distance
        }
        
        initViews()
    }

    func initMapView() {
        
        navigationItem.title = detailInfo.name ?? "当前位置"
        if let latitude = detailInfo.latitude, let longitude = detailInfo.longitude {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.setCenter(location, animated: false)
            mapView.zoomLevel = 13
            let annotation = MAPointAnnotation()
            annotation.coordinate = location
            annotation.title = detailInfo.name
            annotation.subtitle = detailInfo.address

            self.mapView.removeAnnotation(self.poiAnnotation)
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            self.poiAnnotation = annotation;
        }

    }
    
    func initViews() {
        nameLabel.text = detailInfo.name
        addressLabel.text = detailInfo.address
        arriveTimeLabel.text = detailInfo.arriveTime
        arrangeView.isHidden = detailInfo.isArranged
        storedView.isHidden = detailInfo.isStored
        ETALabel.text = detailInfo.eta
        milesLabel.text = detailInfo.distance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func reserveClicked(_ sender: Any) {
        detailInfo.isStored = true
        DMUserDefaults.events.append(detailInfo)
        navigationController?.tabBarController?.selectedIndex = 1
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func arrangeClicked(_ sender: Any) {
        performSegue(withIdentifier: "arrangeSchedule", sender: detailInfo)
    }
    
    @IBAction func goClicked(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "arrangeSchedule" {
            let vc = segue.destination as! ArrangeScheduleViewController
            vc.eventInfo = sender as! EventInfo
            vc.delegate = self
        }
    }
}
