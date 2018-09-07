//
//  EventInfo.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/27.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

@objcMembers class EventInfo: NSObject, NSCoding, AMapSearchDelegate {
    
    var name: String!
    var address: String!
    var city: String!
    var startTime: Date!
    var isArranged: Bool!
    var isStored: Bool!
    var latitude : Double!
    var longitude: Double!
    
    dynamic var miles: Int = 0
    dynamic var duration: Int = 0
    
    var arriveTime: String {
        if let time = startTime {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "M月d日 HH:mm"
            return dateFormat.string(from: time)
        } else {
            return "(显示抵达时间)"
        }
    }

    var distance: String {
        let mileFloat = Float(miles)
        return String(format: "全程大约：%0.1f公里", mileFloat/1000.00)
    }
    
    var eta: String {
        var hour = duration / 3600
        let minutes = duration / 60 % 60
        if hour > 24 {
            let day = hour / 24
            hour = hour % 24
            return "预计用时：\(day)天\(hour)小时\(minutes)分钟"
        } else if hour > 0 {
            return "预计用时：\(hour)小时\(minutes)分钟"
        } else {
            return "预计用时：\(minutes)分钟"
        }
    }
    
    lazy var search: AMapSearchAPI = {
        let search = AMapSearchAPI()
        search?.delegate = self
        return search!
    }()
    
    private let geoCoder = CLGeocoder()
    
    init(name: String, address: String, location: CLLocationCoordinate2D, startTime: Date) {
        super.init()
        self.name = name
        self.startTime = startTime
        self.address = address
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.isArranged = false
        self.isStored = false
        self.searchDistance(from: SingleObjects.shared.userLocation, to: location)
    }
    
    init(event: EKEvent) {
        super.init()
        self.name = event.title
        self.address = event.structuredLocation?.title
        self.startTime = event.startDate
        let location = (event.structuredLocation?.geoLocation?.coordinate)!
        self.longitude = location.longitude
        self.latitude = location.latitude
        self.isArranged = true
        self.isStored = true
        self.searchDistance(from: SingleObjects.shared.userLocation, to: location)
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        startTime = aDecoder.decodeObject(forKey: "startTime") as? Date ?? Date()
        city = aDecoder.decodeObject(forKey: "city") as? String ?? ""
        isArranged = aDecoder.decodeObject(forKey: "isArranged") as? Bool ?? false
        isStored = aDecoder.decodeObject(forKey: "isStored") as? Bool ?? false
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Double ?? 0
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Double ?? 0
        miles = aDecoder.decodeInteger(forKey: "miles")
        duration = aDecoder.decodeInteger(forKey: "duration")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(isArranged, forKey: "isArranged")
        aCoder.encode(isStored, forKey: "isStored")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(miles, forKey: "miles")
        aCoder.encode(duration, forKey: "duration")
    }
    
    func searchDistance(from starCoordinate: CLLocationCoordinate2D, to endCoordinate:CLLocationCoordinate2D) {

        let request = AMapDistanceSearchRequest()
        request.origins = [AMapGeoPoint.location(withLatitude: CGFloat(starCoordinate.latitude), longitude: CGFloat(starCoordinate.longitude))]
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(endCoordinate.latitude), longitude: CGFloat(endCoordinate.longitude))
        search.aMapDistanceSearch(request)
    }

    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {

    }

    func onDistanceSearchDone(_ request: AMapDistanceSearchRequest!, response: AMapDistanceSearchResponse!) {

        if response.results.first != nil {
            let result = response.results.first!
                miles = result.distance
                duration = result.duration
        }
    }
}


