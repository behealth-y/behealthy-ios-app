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
        return String(Int(value)) + "분"
    }
}

