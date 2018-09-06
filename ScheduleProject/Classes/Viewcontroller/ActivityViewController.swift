//
//  ActivityViewController.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/21.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class ActivityViewController: UITableViewController {

    var events: [EventInfo]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarAuthority()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dealEvent()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func dealEvent() {
        events = DMUserDefaults.events
        let eventStore = EKEventStore()
        let startDate = Date().addingTimeInterval(0)
        let endDate = Date().addingTimeInterval(3600 * 24 * 90)
        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                       end: endDate, calendars: nil)
        let eventInfos = eventStore.events(matching: predicate)
            .filter{$0.structuredLocation?.geoLocation != nil}
            .map { EventInfo(event: $0) }
        
        for event in eventInfos {
            if events.contains(event) {
                break
            } else {
                events.append(event)
            }
        }
        events.sort { $0.arriveTime < $1.arriveTime }
    }
    
    private func calendarAuthority() {
    //获取授权状态
        let eventStatus = EKEventStore.authorizationStatus(for: .event)
    //用户还没授权过
        if eventStatus == .notDetermined {
            EKEventStore().requestAccess(to: .event) { (granted, error) in
                if granted {
                    
                }
            }
        } else if eventStatus == .denied {
            let alert = UIAlertController(title: "当前日历服务不可用", message: "您还没有授权本应用使用日历，请到 设置 > 隐私 > 日历 中授权", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default) { (action) in
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

extension ActivityViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "activityCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ActivityTableViewCell
        cell.selectionStyle = .none
        cell.eventInfo = events[indexPath.row]
    
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventInfo = events[indexPath.row]
        performSegue(withIdentifier: "destinationDetail1", sender: eventInfo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "destinationDetail1" {
            if let vc = segue.destination as? DestinationDetailViewController {
                vc.detailInfo = sender as! EventInfo
            }
        }
    }
}
