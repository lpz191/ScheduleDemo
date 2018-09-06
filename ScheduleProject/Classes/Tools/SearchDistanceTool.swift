//
//  SearchDistanceTool.swift
//  ScheduleProject
//
//  Created by pactera on 2018/9/6.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class SearchDistanceTool: NSObject, AMapSearchDelegate {

//    lazy var search: AMapSearchAPI = {
//        let search = AMapSearchAPI()
//        search?.delegate = self
//        return search!
//    }()
//
//    var completionHandlers: (() -> AMapDistanceResult)!
//
//    init(from startCoordinate: CLLocationCoordinate2D, to endCoordinate: CLLocationCoordinate2D) {
//        super.init()
//        let request = AMapDistanceSearchRequest()
//        request.origins = [AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))]
//        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(endCoordinate.latitude), longitude: CGFloat(endCoordinate.longitude))
//        self.search.aMapDistanceSearch(request)
//    }
//
//
////
////    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
////        
////    }
////    
//    func onDistanceSearchDone(_ request: AMapDistanceSearchRequest!, response: AMapDistanceSearchResponse!) {
//        completionHandlers(response.results.first!)
//        completionHandlers().append{
//            return
//        }
//        
////         if let result = response.results.first {
////            miles = result.distance
////            duration = result.duration
////        }
//    }
}
