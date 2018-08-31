//
//  EventInfo.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/27.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class EventInfo: NSObject, AMapSearchDelegate {
    
    var name: String!
    var address: String?
    var miles: String = "（显示公里数）"
    var eta: String = "(显示ETA时间)"
    var arriveTime: String = "(显示抵达时间)"
    var startTime: Date!
    var city: String!
    var isArranged: Bool!
    var location : CLLocationCoordinate2D! {
        didSet {
            searchDistance(from: SingleEvents.userLocation(), to: location)
        }
    }
    
    lazy var search: AMapSearchAPI = {
        let search = AMapSearchAPI()
        search?.delegate = self
        return search!
    }()
    
    private let geoCoder = CLGeocoder()
    
    init(name: String, address: String, arriveTime: String, startTime: Date) {
        self.name = name
        self.arriveTime = arriveTime
        self.startTime = startTime
        self.isArranged = false
    }
    
    init(event: EKEvent) {
        self.name = event.title
        self.address = event.structuredLocation?.title
        self.miles = ""
        self.eta = ""
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "M月d日 HH:mm"
        self.startTime = event.startDate
        self.arriveTime = dateFormat.string(from: event.startDate) + "抵达"
        self.location = (event.structuredLocation?.geoLocation?.coordinate)!
        self.isArranged = true
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
                miles = String(result.distance)
                eta = String(result.duration)
//                self.view.makeToast(String.init(format: "distance search failed :%@", result.info), duration: 1.0)
            }
            else {
//                self.view.makeToast(String.init(format: "driving distance :%ld m, duration :%ld s", result.distance, result.duration), duration: 1.0)
            }
        }
    }

}


class SingleEvents: NSObject {
    static let shared = SingleEvents(events: [], userLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    var events: [EventInfo]
    var userLocation: CLLocationCoordinate2D
    init(events: [EventInfo], userLocation: CLLocationCoordinate2D) {
        self.events = events
        self.userLocation = userLocation
    }
    
    class func events() -> [EventInfo] {
        return shared.events
    }
    
    class func userLocation() -> CLLocationCoordinate2D {
        return shared.userLocation
    }
}
