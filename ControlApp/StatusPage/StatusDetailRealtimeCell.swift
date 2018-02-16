//
//  StatusDetailRealtimeCell.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/30.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
class StatusDetailRealtimeCell:UITableViewCell {
    @IBOutlet weak var tagNameLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!
    func setContent(tagName:String, value:String){
        self.tagNameLabel.text = tagName
        self.valueLabel.text = value
    }
    
}

