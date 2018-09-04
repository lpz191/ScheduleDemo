//
//  EventInfo.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/27.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class EventInfo: NSObject, NSCoding, AMapSearchDelegate {
    
    var name: String!
    var address: String?
    var distance: String = "（显示公里数）"
    var eta: String = "(显示ETA时间)"
    var arriveTime: String = "(显示抵达时间)"
    var startTime: Date! {
        didSet {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "M月d日 HH:mm"
            arriveTime = dateFormat.string(from: startTime) + "抵达"
        }
    }
    var city: String!
    var isArranged: Bool!
    var latitude : Double!
    var longitude: Double!
    
    lazy var search: AMapSearchAPI = {
        let search = AMapSearchAPI()
        search?.delegate = self
        return search!
    }()
    
    private let geoCoder = CLGeocoder()
    
    init(name: String, address: String, location: CLLocationCoordinate2D, startTime: Date) {
        self.name = name
        self.startTime = startTime
        self.address = address
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.isArranged = false
    }
    
    init(event: EKEvent) {
        self.name = event.title
        self.address = event.structuredLocation?.title
        self.distance = ""
        self.eta = ""
        self.startTime = event.startDate
        let location = (event.structuredLocation?.geoLocation?.coordinate)!
        self.longitude = location.longitude
        self.latitude = location.latitude
        self.isArranged = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        distance = aDecoder.decodeObject(forKey: "distance") as? String ?? ""
        eta = aDecoder.decodeObject(forKey: "eta") as? String ?? ""
        arriveTime = aDecoder.decodeObject(forKey: "arriveTime") as? String ?? ""
        startTime = aDecoder.decodeObject(forKey: "startTime") as? Date ?? Date()
        city = aDecoder.decodeObject(forKey: "city") as? String ?? ""
        isArranged = aDecoder.decodeObject(forKey: "isArranged") as? Bool ?? false
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Double ?? 0
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Double ?? 0
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(distance, forKey: "distance")
        aCoder.encode(eta, forKey: "eta")
        aCoder.encode(arriveTime, forKey: "arriveTime")
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(isArranged, forKey: "isArranged")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
    }
    
    func searchDistance(from starCoordinate: CLLocationCoordinate2D, to endCoordinate:CLLocationCoordinate2D) {

        let request = AMapDistanceSearchRequest()
        request.origins = [AMapGeoPoint.location(withLatitude: CGFloat(starCoordinate.latitude), longitude: CGFloat(starCoordinate.longitude))]
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(endCoordinate.latitude), longitude: CGFloat(endCoordinate.longitude))
        search.aMapDistanceSearch(request)
    }

    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
//        let nsErr:NSError? = error as NSError
//        NSLog("Error:\(error) - \(ErrorInfoUtility.errorDescription(withCode: (nsErr?.code)!))")
    }

    func onDistanceSearchDone(_ request: AMapDistanceSearchRequest!, response: AMapDistanceSearchResponse!) {

        if response.results.first != nil {
            let result = response.results.first!
            if (result.info != nil) {
                distance = String(result.distance)
                eta = String(result.duration)
//                self.view.makeToast(String.init(format: "distance search failed :%@", result.info), duration: 1.0)
            }
            else {
//                self.view.makeToast(String.init(format: "driving distance :%ld m, duration :%ld s", result.distance, result.duration), duration: 1.0)
            }
        }
    }

}


