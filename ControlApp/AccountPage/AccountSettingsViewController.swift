//
//  AccountSettingsViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/2/13.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
class AccountSettingsViewController: UITableViewController {
    private var settingItems : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
