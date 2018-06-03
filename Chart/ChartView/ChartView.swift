//
//  ChartView.swift
//  HistogramChart
//
//  Created by amir sheibani on 6/2/18.
//  Copyright © 2018 amir sheibani. All rights reserved.
//

import UIKit

class ChartView: UIView {

    var delegate: ChartDelegate?
    let backGrundColor = UIColor(rgb: 0x193F6C)
    var barChart: StructBarChart!
    var pieChart: StructPieChart!
    var lineChart: StructLineChart!
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = backGrundColor
        let data = delegate?.chartData()
        barChart = data![.bar] as! StructBarChart
        lineChart = data![.line] as! StructLineChart
        pieChart = data![.pie] as! StructPieChart
        
        self.removeAllSubView()
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height{
            //landscape
            let contentScrollView = UIScrollView(frame: rect)
            contentScrollView.isPagingEnabled = true
            var xCoordinate: CGFloat = 0.0
            let viewOne = UIView(frame: CGRect(x: xCoordinate,y: 0.0 ,width: rect.width ,height: rect.height))
            viewOne.backgroundColor = UIColor.clear
            viewOne.removeFromSuperview()
            contentScrollView.addSubview(viewOne)
            
            xCoordinate += rect.width
            let viewTow = UIView(frame: CGRect(x: xCoordinate,y: 0.0 ,width: rect.width ,height: rect.height))
            viewTow.backgroundColor = backGrundColor
            viewTow.removeFromSuperview()
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
            //portrait
            let contentScrollView = UIScrollView(frame: rect)
            contentScrollView.isPagingEnabled = true
            var yCoordinate = CGFloat(0)
            let viewOne = UIView(frame: CGRect(x: 0.0,y: yCoordinate ,width: rect.width ,height: rect.height/2))
            viewOne.backgroundColor = backGrundColor
            viewOne.removeFromSuperview()
            contentScrollView.addSubview(viewOne)
        
            yCoordinate += rect.height / 2
            let viewTow = UIView(frame: CGRect(x: 0.0,y: yCoordinate ,width: rect.width,height: rect.height/2))
            viewTow.backgroundColor = backGrundColor
            viewTow.removeFromSuperview()
            contentScrollView.addSubview(viewTow)
            
            yCoordinate += rect.height / 2
            let viewThere = UIView(frame: CGRect(x: 0.0,y: yCoordinate ,width: rect.width,height: rect.height/2))
            viewThere.backgroundColor = backGrundColor
            viewThere.removeFromSuperview()
            contentScrollView.addSubview(viewThere)
            
            contentScrollView.contentSize = CGSize(width: (rect.width), height: (rect.height / 2) * 3)
            contentScrollView.center = CGPoint(x: rect.width  / CGFloat(2), y: rect.height / CGFloat(2))
            self.addSubview(contentScrollView)
        }
        
    }
    func viewUpdate(){
        self.setNeedsDisplay()
    }
    func creatLineChart(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        let axisView = UIView(frame: CGRect(x: 50, y: 50, width: frame.width - 100, height: frame.height - 100))
        axisView.backgroundColor = UIColor.clear
        
        
        view.addSubview(axisView)
        return view
    }
}
extension UIView {
    func removeAllSubView() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
