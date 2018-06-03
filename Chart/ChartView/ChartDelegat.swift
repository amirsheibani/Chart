//
//  ChartDelegat.swift
//  HistogramChart
//
//  Created by amir sheibani on 6/2/18.
//  Copyright © 2018 amir sheibani. All rights reserved.
//

import UIKit

enum ChartType {
    case line
    case pie
    case bar
}
struct StructLineChart {
    var titleHorizontal: [String]!
    var titleVertical: [String]!
    var dataPoint: [Int]!
}
struct StructPieChart {
    var totalCount: Int!
    var itemsValue: [String : Int]!
    var itemsColor: [UIColor]!
}
struct StructBarChart {
    var titleHorizontal: [String]!
    var titleVertical: [String]!
    var valueDataBarLayerOne: [Int]!
    var valueDataBarLayerTow: [Int]!
}

protocol ChartDelegate{
    func chartData() -> [ChartType : Any]
}

