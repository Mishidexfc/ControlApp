//
//  StatusViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/18.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
////////////////////////////////////////////////////////////
//  Update History:
//  Jan.25th.2018 Transfer the api request functions to EwonApiCase Class
//  Jan.31st.2018 Pull the table view to refresh list and fix bugs.
////////////////////////////////////////////////////////////

import UIKit
import Reachability
import Alamofire
import SwiftyJSON
import ESPullToRefresh

var reachability = Reachability()!
var equipmentList: [EquipmentInfo] = []
var userParameter : UserParameters = UserParameters()
let ewon = EwonApiCase()

class StatusViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate{
    @IBOutlet weak var StatusTable: UITableView!
    @IBOutlet weak var statusLoad: UIActivityIndicatorView!
    private var netState:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StatusTable.delegate = self
        self.StatusTable.dataSource = self
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(reloadTags), userInfo: nil, repeats: true)
        self.StatusTable.es.addPullToRefresh {
            [unowned self] in
            ewon.getEquipListAll(completion: self.updateMyTable)
        }
        statusLoad.startAnimating()
        equipmentList.removeAll()
        ewon.getEquipListAll(completion: self.updateMyTable)
    }
    
    /// Return the state of Internet Connection
    private func getNetState() -> String {
        if (reachability.connection != .none) {
            if (reachability.connection == .wifi){
                return "Wifi"
            }
            
            if (reachability.connection == .cellular) {
                return "3G/4G/LTE"
            }
        }
        return "Disconnected"
    }
    
    /// Reload tag values and update table view
    private func updateMyTable() {
        self.statusLoad.startAnimating()
        self.StatusTable.es.stopPullToRefresh()
        self.StatusTable.reloadData()
        self.statusLoad.stopAnimating()
        self.reloadTags()
    }
    
    /// Reload tags
    @objc private func reloadTags(){
        print("loading")
        for i in 0 ..< equipmentList.count {
            ewon.refreshTagData(deviceIndex: i,completion: self.parseCsv(string:deviceIndex:))
            ewon.getRealtimeAlarm(deviceIndex: i, completion: self.parseCsvForAlarm(string:deviceIndex:))
        }
    }
    
    /// Parse the csv string and store values into equipmentlist
    private func parseCsv(string:String, deviceIndex:Int) {
        let myParser = CsvParser()
        myParser.parseFor = .tags
        let result = myParser.parseString(stringData: string)
        equipmentList[deviceIndex].tags = result
    }
    
    ///
    private func parseCsvForAlarm(string:String, deviceIndex:Int) {
        let myParser = CsvParser()
        myParser.parseFor = .alarms
        let result = myParser.parseString(stringData: string)
        equipmentList[deviceIndex].alarms = result
        self.StatusTable.reloadData()
    }
    
    
    /// Table view functions------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let tempcell = StatusTable.dequeueReusableCell(withIdentifier: "StatusGerneralCell") as! StatusGeneralCell
            var alertNum = 0
            for i in equipmentList {
                for k in i.alarms {
                    alertNum += k.value.count
                }
            }
            tempcell.updateContent(internetStatus: getNetState(),alertNumber: alertNum)
            return tempcell
        case 1:
            let tempcell = StatusTable.dequeueReusableCell(withIdentifier: "StatusEquipmentCell") as! StatusEquipmentCell
            let cellName = equipmentList[indexPath.item].name
            let cellState = equipmentList[indexPath.item].status
            let cellImage = cellState == "offline" ? UIImage(named: "monitor")! : UIImage(named: "monitor2")!
            var alertNum = 0
            for i in equipmentList[indexPath.item].alarms {
                alertNum += i.value.count
            }
            tempcell.setContent(name: cellName, state: cellState, image: cellImage, alarm: alertNum)
            return tempcell
        case 2:
            let tempcell = StatusTable.dequeueReusableCell(withIdentifier: "StatusAddNewCell") as! StatusAddNewCell
            return tempcell
        default:
            break;
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return equipmentList.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 1:
            return "Connections: \(equipmentList.count)\n"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "StatusDetail") as! StatusDetailViewController
            if (equipmentList.count - 1 < indexPath.item) {
                self.StatusTable.deselectRow(at: indexPath, animated: true)
                return
            }
            detailVC.equipIndex = indexPath.item
            detailVC.title = equipmentList[indexPath.item].name
            self.hidesBottomBarWhenPushed = true
            self.StatusTable.deselectRow(at: indexPath, animated: true)
            //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            self.navigationController?.pushViewController(detailVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
    /// Table view functions------------------------------
    ///
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
