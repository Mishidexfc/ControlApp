//
//  StatusDetailCustomeViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/2/15.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit

class StatusDetailCustomeViewController: UITableViewController {
    private var tagList : [String] = []
    private var checkedList : [String] = []
    var parentVC : StatusDetailViewController?
    var deviceIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(self.saveList))
        self.navigationItem.rightBarButtonItem = item
        loadList()
        self.tableView.reloadData()
    }
    
    private func loadList() {
        let tags = equipmentList[deviceIndex].tags.keys
        for temp in tags {
            tagList.append(temp)
        }
    }
    @objc private func saveList(){
        for i in 0 ..< tagList.count {
            let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0))
            if (cell?.accessoryType == .checkmark) {
                self.checkedList.append(tagList[i])
            }
        }
        equipmentList[deviceIndex].tagsDisplay = self.checkedList
        self.parentVC?.tagsList = equipmentList[deviceIndex].tagsDisplay
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomeTag") as! StatusDetailCustomeCell
        cell.tagLabel.text = tagList[indexPath.item]
        cell.accessoryType = equipmentList[deviceIndex].tagsDisplay.contains(cell.tagLabel.text!) ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! StatusDetailCustomeCell
        self.tableView.deselectRow(at: indexPath, animated: true)
        if (cell.accessoryType == .checkmark) {
            cell.accessoryType = .none
        }
        else {
            cell.accessoryType = .checkmark
        }
    }
    
}
