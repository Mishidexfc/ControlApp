//
//  SupportCollectionCell.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/19.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
class SupportCollectionCell : UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    /**
     Set content in cell of Support page
     
     - parameter image:UImage for image of icon in cell
     - parameter text: String for label text
     
     **Note:** For safety and convenient use, please do not change the content of components directly.
     */
    func setContent(image: UIImage, text:String) {
        cellImage.image = image
        cellLabel.text = text
    }
}
