//
//  DetailAlarmViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/3/16.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit

class DetailAlarmViewController: UIViewController {
    @IBOutlet weak var alarmTV: UITextView!
    var deviceIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        var content = ""
        // Display all the alarm history in the textfield
        for i in equipmentList[self.deviceIndex].alarms {
            for k in i.value {
                content += "\n\(i.key) \(k)\n"
            }
        }
        alarmTV.text = content
    }
}
