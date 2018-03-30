//
//  AccountViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/25.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
class AccountViewController:UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var logoutLoading: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
    }
    /// Table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.accountTableView.dequeueReusableCell(withIdentifier: "AccountLogoutCell") as! AccountLogoutCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.item == 0) {
            logoutLoading.startAnimating()
            let cell = self.accountTableView.cellForRow(at: indexPath) as! AccountLogoutCell
            cell.logoutFunc(completion: self.goLoginPage)
        }
        self.accountTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Return to the login page.
    private func goLoginPage(){
        logoutLoading.stopAnimating()
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    ///
}

