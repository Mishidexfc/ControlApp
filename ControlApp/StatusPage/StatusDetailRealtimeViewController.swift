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
    }
    @objc private func reloadData(){
        tagsLabels = equipmentList[deviceIndex].tagsDisplay
        self.realtimeTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = realtimeTable.dequeueReusableCell(withIdentifier: "detailRealtimeCell") as! StatusDetailRealtimeCell
        let tagName = tagsLabels[indexPath.item]
        //let parent = self.parent as! StatusDetailViewController
        let value = equipmentList[deviceIndex].tags[tagName]?.last != nil ? equipmentList[deviceIndex].tags[tagName]?.last : "N/A";
        cell.setContent(tagName: tagName, value: value!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if equipmentList.count - 1 < deviceIndex {
            return 0
        }
        return tagsLabels.count
    }
}
