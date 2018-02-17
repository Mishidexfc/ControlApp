//
//  LoginModel.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/2/16.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import Foundation
class LoginModel {
    /// Send credentials to Ewon by using login api.
    func Login(account:String, userName:String, password: String, completion: @escaping (_ result:String,_ code : Int) -> Void) {
        ewon.verifyKeychain(account: account, userName: userName, password: password, completion: completion)
    }
}
