//
//  AccountLogoutCell.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/25.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
class AccountLogoutCell:UITableViewCell {
    func logoutFunc(completion: @escaping ()->Void){
        ewon.logOut(completion: completion)
    }
}
