//
//  DMUserdefault.swift
//  ScheduleProject
//
//  Created by pactera on 2018/9/4.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class DMUserDefaults: NSObject {
    
    static let singleEventKey = "singleEventKey"
    static let userDefaultStandard = UserDefaults.standard
    
    class var events: [EventInfo]! {
        set {
            var newEvents = [] as [EventInfo]
            
            for eventInfo in newValue {
                let bool1 = newEvents.map { $0.name }.contains(eventInfo.name)
                let bool2 = newEvents.map { $0.arriveTime }.contains(eventInfo.arriveTime)
                if bool1 && bool2 {
                    continue
                } else {
                    newEvents.append(eventInfo)
                }
            }
            newEvents.sort { $0.startTime < $1.startTime }
            let data =  NSKeyedArchiver.archivedData(withRootObject: newEvents)
            userDefaultStandard.removeObject(forKey: singleEventKey)
            userDefaultStandard.set(data, forKey: singleEventKey)
            userDefaultStandard.synchronize()
        }
        get {
            guard let data = userDefaultStandard.object(forKey: singleEventKey) as? Data else { return [] }
            guard let eventInfos = NSKeyedUnarchiver.unarchiveObject(with: data) as? [EventInfo] else {
                return []
            }
            return eventInfos
        }
    }
}
