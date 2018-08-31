//
//  LocationInfo.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/24.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class LocationInfo: NSObject {
    var name : String = ""
    
    var location : CLLocationCoordinate2D
    
    var address : String
    
    var eventInfo: EventInfo {
        return EventInfo(name: name, address: address, arriveTime: "", startTime: Date())
    }
    
    init(name: String, location: CLLocationCoordinate2D, address: String, city: String) {
        self.name = name
        self.location = location
        self.address =  city + address
    }
    
    init(mapPOI: AMapPOI) {
        self.name = mapPOI.name
        self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(mapPOI.location.latitude), longitude: CLLocationDegrees(mapPOI.location.longitude))
        self.address = mapPOI.city + mapPOI.address
    }
}

extension AMapPOI {
    var locationInfo : LocationInfo {
        return LocationInfo(mapPOI: self)
    }
}
