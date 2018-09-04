//
//  SingleObject.swift
//  ScheduleProject
//
//  Created by pactera on 2018/9/4.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class SingleObjects: NSObject {
    
    static let shared = SingleObjects()
    
    private var userLocation: CLLocationCoordinate2D!
    
    class func userLocation(userLocation: CLLocationCoordinate2D) {
        shared.userLocation = userLocation
    }
    
    class func userLocation() -> CLLocationCoordinate2D {
        return shared.userLocation
    }
}
