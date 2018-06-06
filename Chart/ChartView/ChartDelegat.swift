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
enum DataPointStatus{
    case period
    case fertility
    case PMS
    case normal
}
struct DataPoint {
    var temprecher: Int!
    var status: DataPointStatus!
}
struct StructLineChart {
    var titleHorizontal: [String]!
    var titleVertical: [String]!
    var dataPoint: [DataPoint]!
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

