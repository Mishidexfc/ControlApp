//
//  EquipmentInfo.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/24.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
////////////////////////////////////////////////////////////
// Description:
// Class for single equipment with some attributions.
////////////////////////////////////////////////////////////

import Foundation
class EquipmentInfo:Codable {
    var id = ""
    var name = ""
    var encodedName = ""
    var status = ""
    var description = ""
    var customAttributes: [String] = []
    var m2webServer = ""
    var alarms : [String:[String]] = ["TagId":[],"AlarmTime":[],"TagName":[],
                                      "AlStatus":[],"AlType":[],"StatusTime":[],
                                      "UserAck":[],"Description":[],"AlHint":[]]
    /// Tag values which are available for users
    var tags : [String:[String]] = [:]
    var tagsDisplay : [String] = []
    var tagsHistory : [String:[String]] = ["Temp_trend":[],"Level_trend":[],"Hot_Water_Valve":[]]
}

