//
//  UserParameters.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/23.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import Foundation
class UserParameters: NSObject,Codable {
    let t2mdeveloperid = "35823997-2a7f-431a-a524-55965eafbffb"
    var t2maccount = ""
    var t2musername = ""
    var t2mpassword = ""
    var t2msession = ""
    var devicesKeyChain:[String:[String]] = ["TEST":["adm","adm"]]
    var t2mdeviceusername = "adm"
    var t2mdevicepassword = "adm"
    var pools : [[String:String]] = []
}

