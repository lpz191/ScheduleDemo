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
    
    var userLocation: CLLocationCoordinate2D!
    
}
