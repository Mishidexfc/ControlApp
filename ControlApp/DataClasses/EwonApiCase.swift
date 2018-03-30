//
//  EwonApiCase.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/25.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class EwonApiCase {
    
    /**
     - Parameter account: Your ewon account name
     - Parameter userName: Your ewon user name
     - Parameter password: Your ewon username's password
     - Parameter completion: Closure function will be launched asynchronously when receive the response
     
     Send login request to Ewon
     * DeveloperId is loaded from userParameter
     * Use POST http request
     * All responses are in Json format
     * Response has three situations:
     * Success
     * Fail (account,username,password combination is wrong)
     * Failure (Error happened)
     */
    func verifyKeychain(account:String, userName:String, password: String, completion: @escaping (_ result:String,_ code : Int) -> Void) {
        let parameters: Parameters = [
            "t2mdeveloperid": userParameter.t2mdeveloperid,
            "t2maccount": account,
            "t2musername": userName,
            "t2mpassword": password
        ]
        // Send http(POST) request with the above parameters
        Alamofire.request("https://us1.m2web.talk2m.com/t2mapi/login", method: .post, parameters: parameters).responseJSON { response in
            switch (response.result) {
            case .success:
                // Convert the response into Json format
                if let json = response.result.value {
                    let myJson:JSON = JSON(json)
                    print(myJson)
                    // Login successfully or not
                    if myJson["success"].boolValue == true{
                        print(myJson["t2msession"].stringValue)
                        completion(myJson["t2msession"].stringValue,0)
                    }
                    else {
                        completion("fail",0)
                    }
                    
                }
                break
            case .failure(let error):
                // Usually it happens when no connection to Internet
                let code = (error as NSError).code
                completion("error",code)
                break
            }
        }
    }
    
    /**
     - Parameter completion: Closure function will be launched asynchronously when receive the response
     
     Get equipment list from Ewon include the offline ones.
     * All user information for http request are loaded from userParameters
     * Use POST http request
     * All responses are in Json format
     * Success:
     * Load all the result into equipmentList
     * Then launch the completion closure
     */
    func getEquipListAll(completion: @escaping ()->Void) {
        let parameters: Parameters = [
            "t2mdeveloperid": userParameter.t2mdeveloperid,
            "t2msession": userParameter.t2msession,
            "t2maccount": userParameter.t2maccount,
            "t2musername": userParameter.t2musername,
            "t2mpassword": userParameter.t2mpassword
        ]
        
        /// Send http(POST) request with the above parameters
        Alamofire.request("https://us1.m2web.talk2m.com/t2mapi/getewons", method: .post, parameters: parameters).responseJSON { response in
            switch (response.result) {
            case .success:
                /// Convert the response into Json format
                if let json = response.result.value {
                    let myJson:JSON = JSON(json)
                    print(myJson)
                    // Parse the Json
                        equipmentList.removeAll()
                    for temp in myJson["ewons"] {
                        let tempEquip = EquipmentInfo()
                        tempEquip.id = temp.1["id"].stringValue
                        tempEquip.name = temp.1["name"].stringValue
                        tempEquip.encodedName = temp.1["encodedName"].stringValue
                        tempEquip.status = temp.1["status"].stringValue
                        tempEquip.description = temp.1["description"].stringValue
                        for tempAtrribute in temp.1["customAttributes"] {
                            print(tempAtrribute.1.stringValue)
                            tempEquip.customAttributes.append(tempAtrribute.1.stringValue)
                        }
                        tempEquip.m2webServer = temp.1["m2webServer"].stringValue
                        equipmentList.append(tempEquip)
                    }
                    completion()
                }
                break
            case .failure(let error):
                print((error as NSError!).code)
                break
            }
        }
    }
    
    func getTagHistory(startTime:String, endTime:String, deviceIndex:Int, completion: @escaping (String,Int)->Void) {
        let parameters: Parameters = [
            "t2mdeveloperid": userParameter.t2mdeveloperid,
            "AST_Param":"$dtHL$ftT$st\(startTime)$et\(endTime)",
            "t2msession": userParameter.t2msession,
            "t2maccount": userParameter.t2maccount,
            "t2musername": userParameter.t2musername,
            "t2mpassword": userParameter.t2mpassword,
            "t2mdeviceusername": userParameter.t2mdeviceusername,
            "t2mdevicepassword": userParameter.t2mdevicepassword
        ]
        let deviceName = equipmentList[deviceIndex].name
        /// Send http(POST) request with the above parameters
        Alamofire.request("https://us1.m2web.talk2m.com/t2mapi/get/\(deviceName)/rcgi.bin/ParamForm", method: .post, parameters: parameters).responseString { response in
            switch (response.result) {
            case .success:
                /// Convert the response into csv format
                if let myCsv = response.result.value {
                    print(myCsv)
                    completion(myCsv,deviceIndex)
                }
                break
            case .failure(let error):
                print((error as NSError!).code)
                print("error!!!!!!")
                break
            }
        }
    }
    
    /**
     - Parameter deviceIndex: The equipment index in equipmentList
     - Parameter completion: Closure function will be launched asynchronously when receive the response
     
     **Api name actually is 'get' in url address.**
     
     **This name is not recommended but it is just provided by Ewon.**
     
     Get the tag datas in csv format (string)
     * Success: launch the closure
     * Failure: Currently no operation but print error
     * Use Get http request
     */
    func refreshTagData(deviceIndex: Int, completion: @escaping (String,Int)->Void){
        let parameters: Parameters = [
            "AST_Param": "$dtIV$ftT",
            "t2mdeveloperid": userParameter.t2mdeveloperid,
            "t2maccount": userParameter.t2maccount,
            "t2musername": userParameter.t2musername,
            "t2mpassword": userParameter.t2mpassword,
            "t2mdeviceusername": userParameter.t2mdeviceusername,
            "t2mdevicepassword": userParameter.t2mdevicepassword
        ]
        let deviceName = equipmentList[deviceIndex].name
        /// Send http(POST) request with the above parameters
        let tagUrl = "https://us1.m2web.talk2m.com/t2mapi/get/\(deviceName)/rcgi.bin/ParamForm" as URLConvertible
        Alamofire.request(tagUrl, method: .post, parameters: parameters).responseString { response in
            switch (response.result) {
            case .success:
                /// Convert the response into csv format
                if let myCsv = response.result.value {
                    print(myCsv)
                    completion(myCsv,deviceIndex)
                }
                break
            case .failure(let error):
                print((error as NSError!).code)
                print("error!!!!!!")
                break
            }
        }
    }
    
    ///
    func logOut(completion: @escaping ()->Void) {
        let parameters: Parameters = [
            "t2mdeveloperid": userParameter.t2mdeveloperid,
            "t2msession": userParameter.t2msession,
            "t2maccount": userParameter.t2maccount,
            "t2musername": userParameter.t2musername,
            "t2mpassword": userParameter.t2mpassword
        ]
        /// Send http(POST) request with the above parameters
        let tagUrl = "https://us1.m2web.talk2m.com/t2mapi/logout" as URLConvertible
        Alamofire.request(tagUrl, method: .post, parameters: parameters).responseJSON { response in
            switch (response.result) {
            case .success:
                /// Convert the response into csv format
                if let json = response.result.value {
                    let myJson = JSON(json)
                    print(myJson)
                    // Log out successfully or not
                    if (myJson["success"].boolValue == true) {
                        print("success log out")
                    }
                    else {
                        print("fail log out")
                    }
                }
                completion()
                break
            case .failure(let error):
                print((error as NSError!).code)
                print("error!!!!!!")
                completion()
                break
            }
        }
    }
    
    ///
    func getRealtimeAlarm(deviceIndex: Int, completion: @escaping (String,Int)->Void) {
        let parameters: Parameters = [
            "AST_Param": "$dtAR$ftT",
            "t2mdeveloperid": userParameter.t2mdeveloperid,
            "t2maccount": userParameter.t2maccount,
            "t2musername": userParameter.t2musername,
            "t2mpassword": userParameter.t2mpassword,
            "t2mdeviceusername": userParameter.t2mdeviceusername,
            "t2mdevicepassword": userParameter.t2mdevicepassword
        ]
        let deviceName = equipmentList[deviceIndex].name
        /// Send http(POST) request with the above parameters
        let tagUrl = "https://us1.m2web.talk2m.com/t2mapi/get/\(deviceName)/rcgi.bin/ParamForm" as URLConvertible
        Alamofire.request(tagUrl, method: .post, parameters: parameters).responseString { response in
            switch (response.result) {
            case .success:
                /// Convert the response into csv format
                if let myCsv = response.result.value {
                    print(myCsv)
                    completion(myCsv,deviceIndex)
                }
                break
            case .failure(let error):
                print((error as NSError!).code)
                print("error!!!!!!")
                break
            }
        }
    }
    /**
     private func updateEquipList(completion: @escaping ()->Void) {
     let parameters: Parameters = [
     "t2mdeveloperid": userParameter.t2mdeveloperid,
     "t2maccount": userParameter.t2maccount,
     "t2musername": userParameter.t2musername,
     "t2mpassword": userParameter.t2mpassword
     ]
     /// Send http(POST) request with the above parameters
     Alamofire.request("https://m2web.talk2m.com/t2mapi/getaccountinfo", method: .post, parameters: parameters).responseJSON { response in
     switch (response.result) {
     case .success:
     /// Convert the response into Json format
     if let json = response.result.value {
     let myJson:JSON = JSON(json)
     print(myJson)
     for temp in myJson["pools"] {
     print(temp.1["id"].stringValue)
     print(temp.1["name"].stringValue)
     userParameter.pools.append([temp.1["id"].stringValue : temp.1["name"].stringValue])
     }
     completion()
     }
     break
     case .failure(let error):
     print((error as NSError!).code)
     break
     }
     }
     }*/
    
    /*
     private func getEquipListByPoolIds() {
     let pools = userParameter.pools
     for pool in pools {
     for (key,value) in pool {
     print(key + value)
     }
     }
     }*/
}
