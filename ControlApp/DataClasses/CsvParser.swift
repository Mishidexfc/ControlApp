//
//  CsvParser.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/24.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import Foundation
class CsvParser {
    private var csvResult = [String:[String]]()
    enum parseReason {
        case tags
        case alarms
        case history
    }
    private let equipRefer = EquipmentInfo()
    var parseFor : parseReason = .tags
    init() {
        
    }
    
    func parseString(stringData:String) -> [String:[String]] {
        var tempStringArr = parseStringToLines(stringData: stringData)
        for item in tempStringArr {
            if  let index = tempStringArr.index(of: item) {
                if item == "" {
                    tempStringArr.remove(at: index)
                }
            }
        }
        for i in 0..<tempStringArr.count {
            parseSingleLineOfString(stringData: tempStringArr[i], lineIndex: i)
        }
        return csvResult
    }
    
    private func parseStringToLines(stringData:String) -> [String] {
        var result : [String] = []
        result = stringData.components(separatedBy: CharacterSet.newlines)
        return result
    }
    
    private func parseSingleLineOfString(stringData:String, lineIndex: Int){
        if (stringData == "") {
            return
        }
        var result = stringData.components(separatedBy: ";")
        for i in 0 ..< result.count {
            result[i] = result[i].trimmingCharacters(in: .punctuationCharacters)
        }
        if (lineIndex != 0) {
            switch parseFor {
            case .tags:
                    if (csvResult[result[1]] == nil) {
                        csvResult[result[1]] = []
                    }
                    csvResult[result[1]]!.append(result[2])
                break
            case .history:
               
                    if (csvResult[result[1]] == nil) {
                        csvResult[result[1]] = []
                    }
                    csvResult[result[1]]!.append(result[1])
                    csvResult[result[1]]!.append(result[4])
                
                break
            default:
                break
            }
        }
    }
    
    func retrieveLastResult() -> [String:[String]] {
        return csvResult
    }
}
