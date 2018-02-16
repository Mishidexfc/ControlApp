//
//  StatusGeneralCell.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/23.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
class StatusGeneralCell:UITableViewCell {
    @IBOutlet weak var internetLabel: UILabel!
    @IBOutlet weak var alertLabel:UILabel!
    func updateContent(internetStatus:String,alertNumber:Int) {
        internetLabel.text = "Internet: \(internetStatus)"
        alertLabel.text = "Alerts: \(alertNumber)"
    }
}
