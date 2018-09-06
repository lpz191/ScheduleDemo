//
//  ArrangeScheduleViewController.swift
//  ScheduleProject
//
//  Created by pactera on 2018/8/31.
//  Copyright © 2018年 pactera. All rights reserved.
//

import UIKit

class ArrangeScheduleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: DestinationDetailViewController?
    
    var eventInfo: EventInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(90 * 3600 * 24)
        titleLabel.isHidden = true
        nameLabel.text = eventInfo.name
        addressLabel.text = eventInfo.address
    }
    
    @IBAction func arrange(_ sender: Any) {
        dismiss(animated: true) {
            self.eventInfo.startTime = self.datePicker.date
            self.eventInfo.isArranged = true
            DMUserDefaults.events.append(self.eventInfo)
            self.delegate?.navigationController?.tabBarController?.selectedIndex = 1
            self.delegate?.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
}
