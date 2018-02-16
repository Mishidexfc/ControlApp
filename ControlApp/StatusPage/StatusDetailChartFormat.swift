//
//  StatusDetailChartFormat.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/2/1.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import Charts

class StatusDetailChartFormat:NSObject,IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return timeIntervalToString(interval: value)
    }
    private func timeIntervalToString(interval:Double) ->String {

        let timeStamp = Double(interval)
        

        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)

        let dformatter = DateFormatter()
        dformatter.dateFormat = "MM-dd HH:mm"
        
        return dformatter.string(from: date)
    }
}
