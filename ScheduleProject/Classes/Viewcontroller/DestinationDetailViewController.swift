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
    @IBOutlet weak var arrangeButton: UIButton!
    
    var detailInfo : EventInfo!
    
    var poiAnnotation: MAPointAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()

        initMapView()
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
        milesLabel.text = detailInfo.distance
        ETALabel.text = detailInfo.eta
        arriveTimeLabel.text = detailInfo.arriveTime
        arrangeButton.isHidden = detailInfo.isArranged
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func reserveClicked(_ sender: Any) {
        DMUserDefaults.events.append(detailInfo)
        navigationController?.tabBarController?.selectedIndex = 1
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
