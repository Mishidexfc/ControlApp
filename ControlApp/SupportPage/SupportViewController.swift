//
//  SupportViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/19.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
////////////////////////////////////////////////////////////
//  Update History:
////////////////////////////////////////////////////////////

import UIKit
import MessageUI

class SupportViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    /// Few titles and images, so hardcode here
    private let titles = ["Contact us","Guidance","Email","Our website"]
    private let images = ["phone","book","message","globe_earth"]
    
    @IBOutlet weak var supportCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.supportCollectionView.alwaysBounceVertical = true
        supportCollectionView.delegate = self
        supportCollectionView.dataSource = self
    }
    
    /// Define the number of session, default 1 no need to be changed in this case
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// Define the number of cells in each session.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    /// Do something for each cell like add image, change label color
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = supportCollectionView.dequeueReusableCell(withReuseIdentifier: "supportcell", for: indexPath) as! SupportCollectionCell
        let image = UIImage(named: images[indexPath.item])!
        cell.setContent(image: image,text: titles[indexPath.item])
        return cell
    }
    
    /// Launch the corresponding feature when select one of cell.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            guard let number = URL(string: "tel://7168752000") else { return }
            UIApplication.shared.open(number)
        case 1:
            break
        case 2:
            guard let emailAddress = URL(string: "mailto://sales.niagara@alfalaval.com") else { return }
            UIApplication.shared.open(emailAddress,options: [:],completionHandler: nil)
        case 3:
            guard let webAddress = URL(string:"http://www.niagarablower.com") else { return }
            UIApplication.shared.open(webAddress, options: [:], completionHandler: nil)
        default:
            break
        }
    }
}
