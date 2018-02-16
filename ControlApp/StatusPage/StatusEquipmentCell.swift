//
//  StatusEquipmentCell.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/24.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
class StatusEquipmentCell: UITableViewCell {
    @IBOutlet weak var equipmentNameLabel : UILabel!
    @IBOutlet weak var equipmentStateLabel : UILabel!
    @IBOutlet weak var equipmentImage: UIImageView!
    func setContent(name:String, state:String, image:UIImage) {
        equipmentNameLabel.text = name
        equipmentStateLabel.text = state
        equipmentImage.image = image
    }
}
