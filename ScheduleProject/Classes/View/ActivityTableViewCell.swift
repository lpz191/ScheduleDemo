//
//  ActivityTableViewCell.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/27.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ETALabel: UILabel!
    @IBOutlet weak var arriveTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    private var _eventInfo : EventInfo!
    
    var eventInfo : EventInfo {
        set {
            _eventInfo = newValue
            nameLabel.text = newValue.name
            addressLabel.text = newValue.address
            ETALabel.text = newValue.eta
            arriveTimeLabel.text = newValue.arriveTime
            distanceLabel.text = newValue.distance
        }
        get {
            return _eventInfo
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    @IBAction func goClick(_ sender: UIButton) {
    }
    
}
