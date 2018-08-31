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
    
    var detailInfo : EventInfo!
    
    var poiAnnotation: MAPointAnnotation!

    override func viewDidLoad() {
        super.viewDidLoad()

        initMapView()
        initViews()
    }

    func initMapView() {
        
        navigationItem.title = detailInfo.name ?? "当前位置"
        if let location = detailInfo.location {
            mapView.setCenter(location, animated: false)
            mapView.zoomLevel = 13
            let annotation = MAPointAnnotation()
            annotation.coordinate = location
            annotation.title = detailInfo.name
            annotation.subtitle = detailInfo.address
            /* Remove prior annotation. */
            self.mapView.removeAnnotation(self.poiAnnotation)
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            self.poiAnnotation = annotation;
        }

    }
    
    func initViews() {
        nameLabel.text = detailInfo.name
        addressLabel.text = detailInfo.address
        milesLabel.text = detailInfo.miles
        ETALabel.text = detailInfo.eta
        arriveTimeLabel.text = detailInfo.arriveTime
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func reserveClicked(_ sender: Any) {
        
    }
    
    @IBAction func arrangeClicked(_ sender: Any) {
        
    }
    
    @IBAction func goClicked(_ sender: Any) {
        
    }
}
