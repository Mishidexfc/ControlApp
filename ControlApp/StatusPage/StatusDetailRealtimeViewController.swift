//
//  StatusDetailRealtimeViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/30.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
import ESPullToRefresh
class StatusDetailRealtimeViewController:UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var realtimeTable:UITableView!
    var deviceIndex: Int = 0
    var tagsLabels : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tagsLabels.removeAll()
        tagsLabels = equipmentList[deviceIndex].tagsDisplay
        self.realtimeTable.dataSource = self
        self.realtimeTable.delegate = self
        reloadData()
        self.realtimeTable.es.addPullToRefresh {
            [unowned self] in
            self.reloadData()
            self.realtimeTable.es.stopPullToRefresh()
        }
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(reloadData), userInfo: nil, repeats: true)
        equipmentList[deviceIndex].tagsDisplay.removeAll()
        if let myData = UserDefaults.standard.value(forKey: "tagsDisplay") as? Data{
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode([EquipmentInfo].self, from: myData) {
                let temp : [EquipmentInfo] = objectsDecoded
                if (equipmentList[deviceIndex].name == temp[deviceIndex].name) {
                    equipmentList[deviceIndex].tagsDisplay = temp[deviceIndex].tagsDisplay
                }
            }
        }
    }
    @objc private func reloadData(){
        guard deviceIndex < equipmentList.count else{
            return
        }
        tagsLabels = equipmentList[deviceIndex].tagsDisplay
        self.realtimeTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            /*let cell = realtimeTable.dequeueReusableCell(withIdentifier: "detailImageCell") as! StatusDetailImageCell
            cell.levelTrendLabel.text = equipmentList[deviceIndex].tags["Level_trend"]?.last != nil ? equipmentList[deviceIndex].tags["Level_trend"]?.last : "N/A"
            cell.airTempLabel.text = equipmentList[deviceIndex].tags["Temp_trend"]?.last != nil ? equipmentList[deviceIndex].tags["Temp_trend"]?.last : "N/A"
            cell.hotWaterLabel.text = equipmentList[deviceIndex].tags["Hot_Water_Valve"]?.last != nil ? equipmentList[deviceIndex].tags["Hot_Water_Valve"]?.last : "N/A"
            return cell*/
            break
        case 1:
            let cell = realtimeTable.dequeueReusableCell(withIdentifier: "detailRealtimeCell") as! StatusDetailRealtimeCell
            let tagName = tagsLabels[indexPath.item]
            //let parent = self.parent as! StatusDetailViewController
            let value = equipmentList[deviceIndex].tags[tagName]?[0] != nil ? equipmentList[deviceIndex].tags[tagName]?[0] : "N/A";
            cell.setContent(tagName: tagName, value: value!)
            return cell
        case 2:
            break
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0){
            return 200
        }
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if equipmentList.count - 1 < deviceIndex {
                return 0
            }
            return tagsLabels.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}
