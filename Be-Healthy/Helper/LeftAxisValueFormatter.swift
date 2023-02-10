//
//  LeftAxisValueFormatter.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/06.
//

import UIKit
import Charts

class LeftAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let minute = Int(value)
        
        if minute > 60 {
            let hour: Int = minute / 60
            
            return "\(hour)시간"
        } else {
            return "\(minute)분"
        }
    }
}

class MinuteValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: Charts.ChartDataEntry, dataSetIndex: Int, viewPortHandler: Charts.ViewPortHandler?) -> String {
        let minute = Int(value)
        
        if minute > 60 {
            return minute.minuteToTime()
        } else {
            return "\(minute)분"
        }
    }
}

