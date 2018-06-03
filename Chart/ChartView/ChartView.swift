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
    var barChart: StructBarChart!
    var pieChart: StructPieChart!
    var lineChart: StructLineChart!
    
    var lineChartRightMargin = CGFloat(50)
    var lineChartLeftMargin = CGFloat(10)
    var lineChartTopMargin = CGFloat(10)
    var lineChartDownMargin = CGFloat(50)
    
    var lineChartTitle = "Line Chart Title"
    var lineChartTitleColor = UIColor.white
    var rotationState: RotationState!
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = backGrundColor
        let data = delegate?.chartData()
        barChart = data![.bar] as! StructBarChart
        lineChart = data![.line] as! StructLineChart
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
            viewOne.backgroundColor = UIColor.clear
            viewOne.removeFromSuperview()
            viewOne.addSubview(createLineChartMax(frame: rect))
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
            let contentScrollView = UIScrollView(frame: rect)
            contentScrollView.isPagingEnabled = true
            var yCoordinate = CGFloat(0)
            let viewOne = UIView(frame: CGRect(x: 0.0,y: yCoordinate ,width: rect.width ,height: rect.height/2))
            viewOne.backgroundColor = backGrundColor
            viewOne.removeFromSuperview()
            viewOne.addSubview(createLineChartMin(frame: rect))
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
    func addDataPoint(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(rgb: 0x0000ff).cgColor, UIColor.clear.cgColor]
        
        
        
        view.backgroundColor = UIColor.clear
        let v = frame.width / CGFloat(lineChart.titleHorizontal.count)
        let h = frame.height / CGFloat(lineChart.titleVertical.count)
        var count = lineChart.titleVertical.count - 1
        var lastPoint = CGPoint.zero
        let linePath = UIBezierPath()
        let clippingPath = UIBezierPath()
        var listPoint = [CGPoint]()
        for index in 1...lineChart.dataPoint.count{
            let pointPath = UIBezierPath()
            count -= fundIndexValue(value: lineChart.dataPoint[index - 1], in: lineChart.titleVertical)
            let point = CGPoint(x: v * CGFloat(index), y: h * CGFloat(count))
            listPoint.append(point)
            pointPath.addArc(withCenter: point, radius: 3, startAngle: 0, endAngle: .pi*2, clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = pointPath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1.0
            view.layer.addSublayer(shapeLayer)
            count = lineChart.titleVertical.count - 1
            
            if lastPoint != CGPoint.zero{
                linePath.move(to: lastPoint)
                clippingPath.move(to: lastPoint)
                linePath.addLine(to: point)
                clippingPath.addLine(to: point)
                let lineShapeLayer = CAShapeLayer()
                lineShapeLayer.path = linePath.cgPath
                lineShapeLayer.strokeColor = UIColor.white.cgColor
                lineShapeLayer.lineWidth = 1
                view.layer.addSublayer(lineShapeLayer)
            }
            lastPoint = point
        }
        clippingPath.move(to: lastPoint)
        clippingPath.addLine(to: CGPoint(x: lastPoint.x, y:frame.height))
        
        clippingPath.move(to: CGPoint(x: lastPoint.x, y:frame.height))
        clippingPath.addLine(to: CGPoint(x: (listPoint.first?.x)!, y:frame.height))
        
        clippingPath.move(to: CGPoint(x: (listPoint.first?.x)!, y:frame.height))
        clippingPath.addLine(to: CGPoint(x: (listPoint.first?.x)!, y:(listPoint.first?.y)!))
        clippingPath.close()
//        clippingPath.addClip()
        let lineShapeLayer = CAShapeLayer()
        lineShapeLayer.path = clippingPath.cgPath
        lineShapeLayer.strokeColor = UIColor.white.cgColor
        
        lineShapeLayer.lineWidth = 1
        lineShapeLayer.fillRule = kCAFillRuleNonZero
        lineShapeLayer.fillColor = UIColor.yellow.cgColor
        view.layer.addSublayer(lineShapeLayer)
//        gradientLayer.mask = lineShapeLayer
        
//        view.layer.addSublayer(gradientLayer)
//        let rectPath = UIBezierPath(rect: frame)
//        rectPath.fill()
        
        return view
    }
    func fundIndexValue(value: Int,in list:[String]) -> Int{
        var i = 0
        for index in 0..<list.count{
            if list[index] == "\(value)"{
                i = index
                break
            }
        }
        return i
    }
    func createAxisLabel(frame: CGRect,state: LabelFrameState) -> UIView {
        let view = UIView(frame: frame)
        if state == .vertical{
            view.backgroundColor = UIColor.clear
            let x = CGFloat(0)
            let y = CGFloat(0)
            let width = frame.width
            let height = frame.height / CGFloat(lineChart.titleVertical.count)
            
            for index in 1...lineChart.titleVertical.count{
                let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
                label.center = CGPoint(x: width/2, y: (height * CGFloat((lineChart.titleVertical.count + 1) - index)) - (height/2))
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.text = lineChart.titleVertical[index - 1]
                view.addSubview(label)
            }
        }else{
            view.backgroundColor = UIColor.clear
            
            let x = CGFloat(0)
            let y = CGFloat(0)
            let width = frame.width / CGFloat(lineChart.titleHorizontal.count)
            let height = frame.height
            
            for index in 1...lineChart.titleHorizontal.count{
                let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height/2))
                label.center = CGPoint(x: (width *  CGFloat(index)) - (width/2), y: height/3)
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.text = lineChart.titleHorizontal[index - 1]
                if rotationState == .landscape{
                    label.font = UIFont(name: label.font.fontName, size: 14)
                }else{
                    label.font = UIFont(name: label.font.fontName, size: 8)
                }
                
                view.addSubview(label)
                
            }
            
        }
        return view
    }
    func createLineChartMin(frame: CGRect) -> UIView{
        
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        
        var x = lineChartRightMargin
        var y = lineChartTopMargin
        var width = CGFloat(200)
        var height = CGFloat(30)
        let titel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        titel.center = CGPoint(x: view.frame.size.width / 2, y: height)
        titel.text = lineChartTitle
        titel.textAlignment = .center
        titel.font = UIFont(name: titel.font.fontName, size: 18)
        titel.textColor = lineChartTitleColor
        view.addSubview(titel)
        
        x = lineChartRightMargin
        y = lineChartTopMargin
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = (frame.height / 2) - lineChartDownMargin
        view.addSubview(createAxis(frame: CGRect(x: x, y: y, width: width, height: height)))
        
        x = lineChartRightMargin
        y = lineChartTopMargin + 30
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = (frame.height / 2) - lineChartDownMargin - 30
        view.addSubview(addDivider(frame: CGRect(x: x, y: y, width: width, height: height),state: .horizontal))
        
        x = lineChartRightMargin
        y = lineChartTopMargin + 30
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = (frame.height / 2) - lineChartDownMargin - 30
        view.addSubview(addDivider(frame: CGRect(x: x, y: y, width: width, height: height),state: .vertical))
        
        x = 0
        y = lineChartTopMargin + 30
        width = lineChartRightMargin
        height = (frame.height / 2) - lineChartDownMargin - 30
        let vertcalLabelFrame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(createAxisLabel(frame: vertcalLabelFrame,state: .vertical))
        
        x = lineChartRightMargin
        y = (frame.height / 2) - lineChartDownMargin + lineChartTopMargin
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = lineChartDownMargin
        let horizontalLabelFrame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(createAxisLabel(frame: horizontalLabelFrame,state: .horizontal))
        
        x = lineChartRightMargin
        y = lineChartTopMargin + 30
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = (frame.height / 2) - lineChartDownMargin - 30
        view.addSubview(addDataPoint(frame: CGRect(x: x, y: y, width: width, height: height)))
        
        return view
    }
    
    func createLineChartMax(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        
        var x = lineChartRightMargin
        var y = lineChartTopMargin
        var width = CGFloat(200)
        var height = CGFloat(30)
        let titel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        titel.center = CGPoint(x: view.frame.size.width / 2, y: height)
        titel.text = lineChartTitle
        titel.textAlignment = .center
        titel.font = UIFont(name: titel.font.fontName, size: 18)
        titel.textColor = lineChartTitleColor
        view.addSubview(titel)
        
        x = lineChartRightMargin
        y = lineChartTopMargin
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = frame.height - lineChartDownMargin
        view.addSubview(createAxis(frame: CGRect(x: x, y: y, width: width, height: height)))
        
        x = lineChartRightMargin
        y = lineChartTopMargin + 30
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = frame.height - lineChartDownMargin - 30
        view.addSubview(addDivider(frame: CGRect(x: x, y: y, width: width, height: height),state: .horizontal))
        
        x = lineChartRightMargin
        y = lineChartTopMargin + 30
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = frame.height - lineChartDownMargin - 30
        view.addSubview(addDivider(frame: CGRect(x: x, y: y, width: width, height: height),state: .vertical))
        
        x = 0
        y = lineChartTopMargin + 30
        width = lineChartRightMargin
        height = frame.height - lineChartDownMargin - 30
        let vertcalLabelFrame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(createAxisLabel(frame: vertcalLabelFrame,state: .vertical))
        
        x = lineChartRightMargin
        y = frame.height - lineChartDownMargin + lineChartTopMargin
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = lineChartDownMargin
        let horizontalLabelFrame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(createAxisLabel(frame: horizontalLabelFrame,state: .horizontal))
        
        x = lineChartRightMargin
        y = lineChartTopMargin + 30
        width = frame.width - lineChartRightMargin - lineChartLeftMargin
        height = frame.height - lineChartDownMargin - 30
        view.addSubview(addDataPoint(frame: CGRect(x: x, y: y, width: width, height: height)))
        
        return view
    }
    
    func createAxis(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        
        let verticalAxisPath = UIBezierPath()
        verticalAxisPath.move(to: CGPoint(x: 0, y: frame.height))
        verticalAxisPath.addLine(to: CGPoint(x: 0 , y: 0))
        let verticalShapeLayer = CAShapeLayer()
        verticalShapeLayer.path = verticalAxisPath.cgPath
        verticalShapeLayer.strokeColor = UIColor.white.cgColor
        verticalShapeLayer.lineWidth = 1
        view.layer.addSublayer(verticalShapeLayer)
        
        let horizontalAxisPath = UIBezierPath()
        horizontalAxisPath.move(to: CGPoint(x: 0, y: frame.height))
        horizontalAxisPath.addLine(to: CGPoint(x: frame.width , y: frame.height))
        let horizontalShapeLayer = CAShapeLayer()
        horizontalShapeLayer.path = horizontalAxisPath.cgPath
        horizontalShapeLayer.strokeColor = UIColor.white.cgColor
        horizontalShapeLayer.lineWidth = 1
        view.layer.addSublayer(horizontalShapeLayer)
        return view
    }
    func addDivider(frame: CGRect,state: DividerState) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        if state == .horizontal{
            let h = frame.height / CGFloat(lineChart.titleVertical.count)
            for index in (0...lineChart.titleVertical.count).reversed(){
                let verticalAxisPath = UIBezierPath()
                verticalAxisPath.move(to: CGPoint(x: 0, y: h * CGFloat(index)))
                verticalAxisPath.addLine(to: CGPoint(x: frame.width , y: h * CGFloat(index)))
                let verticalShapeLayer = CAShapeLayer()
                verticalShapeLayer.path = verticalAxisPath.cgPath
                verticalShapeLayer.strokeColor = UIColor(rgb: 0xffffff).withAlphaComponent(0.5).cgColor
                verticalShapeLayer.lineDashPattern = [14 , 4]
                verticalShapeLayer.lineWidth = 0.25
                view.layer.addSublayer(verticalShapeLayer)
            }
        }else{
            let v = frame.width / CGFloat(lineChart.titleHorizontal.count)
            for index in 1...lineChart.titleHorizontal.count{
                let horizontalAxisPath = UIBezierPath()
                horizontalAxisPath.move(to: CGPoint(x: v * CGFloat(index), y: frame.height))
                horizontalAxisPath.addLine(to: CGPoint(x: v * CGFloat(index) , y: 0))
                let horizontalShapeLayer = CAShapeLayer()
                horizontalShapeLayer.path = horizontalAxisPath.cgPath
                horizontalShapeLayer.strokeColor = UIColor(rgb: 0xffffff).withAlphaComponent(0.5).cgColor
                horizontalShapeLayer.lineDashPattern = [14 , 4]
                horizontalShapeLayer.lineWidth = 0.25
                view.layer.addSublayer(horizontalShapeLayer)
            }
        }
        return view
    }
}



extension UIView {
    func removeAllSubView() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
