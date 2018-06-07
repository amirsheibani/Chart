//
//  ChartView.swift
//  HistogramChart
//
//  Created by amir sheibani on 6/2/18.
//  Copyright © 2018 amir sheibani. All rights reserved.
//

import UIKit

enum LabelFrameState {
    case horizontal
    case vertical
}
enum DividerState {
    case horizontal
    case vertical
}
enum RotationState {
    case landscape
    case portrait
}
class ChartView: UIView {

    var delegate: ChartDelegate?
    let backGrundColor = UIColor(rgb: 0x193F6C)
    var barChartData: StructBarChart!
    var pieChart: StructPieChart!
    var lineChartData: StructLineChart!
    
    var rotationState: RotationState!
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = backGrundColor
        let data = delegate?.chartData()
        barChartData = data![.bar] as! StructBarChart
        lineChartData = data![.line] as! StructLineChart
        pieChart = data![.pie] as! StructPieChart
        
        self.removeAllSubView()
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height{
            rotationState = .landscape
        }else{
            rotationState = .portrait
        }
        if rotationState == .landscape{
            
            let contentScrollView = UIScrollView(frame: rect)
            contentScrollView.isPagingEnabled = true
            var xCoordinate: CGFloat = 0.0
            let viewOne = UIView(frame: CGRect(x: xCoordinate,y: 0.0 ,width: rect.width ,height: rect.height))
            viewOne.backgroundColor = backGrundColor
            viewOne.removeFromSuperview()
            let lineChart = LineChart(lineChart: lineChartData,rotationState: rotationState,lineChartTitle: "Line Chart Title",lineChartTitleColor: UIColor.white)
            viewOne.addSubview(lineChart.createLineChartMax(frame: rect))
            contentScrollView.addSubview(viewOne)
            
            xCoordinate += rect.width
            let viewTow = UIView(frame: CGRect(x: xCoordinate,y: 0.0 ,width: rect.width ,height: rect.height))
            viewTow.backgroundColor = backGrundColor
            viewTow.removeFromSuperview()
            let barChart = BarChart(barChart: barChartData, rotationState: rotationState, barChartTitle: "Bar Chart Title", barChartTitleColor: UIColor.white)
            viewTow.addSubview(barChart.createBarChartMax(frame: rect))
            contentScrollView.addSubview(viewTow)

            xCoordinate += rect.width
            let viewThere = UIView(frame: CGRect(x: xCoordinate,y: 0.0 ,width: rect.width ,height: rect.height))
            viewThere.backgroundColor = backGrundColor
            viewThere.removeFromSuperview()
            contentScrollView.addSubview(viewThere)
            
            contentScrollView.contentSize = CGSize(width: (rect.width * 3), height: rect.height)
            contentScrollView.center = CGPoint(x: rect.width  / CGFloat(2), y: rect.height / CGFloat(2))
            self.addSubview(contentScrollView)
        }else{
            
            let contentScrollView = UIScrollView(frame: rect)
            contentScrollView.isPagingEnabled = true
            var yCoordinate = CGFloat(0)
            let viewOne = UIView(frame: CGRect(x: 0.0,y: yCoordinate ,width: rect.width ,height: rect.height/2))
            viewOne.backgroundColor = backGrundColor
            viewOne.removeFromSuperview()
            let lineChart = LineChart(lineChart: lineChartData,rotationState: rotationState,lineChartTitle: "Line Chart Title",lineChartTitleColor: UIColor.white)
            viewOne.addSubview(lineChart.createLineChartMin(frame: rect))
            contentScrollView.addSubview(viewOne)
        
            yCoordinate += rect.height / 2
            let viewTow = UIView(frame: CGRect(x: 0.0,y: yCoordinate ,width: rect.width,height: rect.height/2))
            viewTow.backgroundColor = backGrundColor
            viewTow.removeFromSuperview()
            let barChart = BarChart(barChart: barChartData, rotationState: rotationState, barChartTitle: "Bar Chart Title", barChartTitleColor: UIColor.white)
            viewTow.addSubview(barChart.createBarChartMin(frame: rect))
            contentScrollView.addSubview(viewTow)
            
            yCoordinate += rect.height / 2
            let viewThere = UIView(frame: CGRect(x: 0.0,y: yCoordinate ,width: rect.width,height: rect.height))
            viewThere.backgroundColor = backGrundColor
            viewThere.removeFromSuperview()
            
            contentScrollView.addSubview(viewThere)
            
            contentScrollView.contentSize = CGSize(width: (rect.width), height: (rect.height) * 2)
            contentScrollView.center = CGPoint(x: rect.width  / CGFloat(2), y: rect.height / CGFloat(2))
            self.addSubview(contentScrollView)
        }
        
    }
    func viewUpdate(){
        self.setNeedsDisplay()
    }
}
extension UIView {
    func removeAllSubView() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
