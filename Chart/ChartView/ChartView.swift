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
    var pointLocation = [CGPoint]()
    
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
    func createAreaForPoints(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        let areaPath = UIBezierPath()
        var myPointLocation = pointLocation
        myPointLocation.append(CGPoint(x: (pointLocation.last?.x)!, y:frame.height))
        myPointLocation.append(CGPoint(x: (pointLocation.first?.x)!, y:frame.height))
        myPointLocation.append(CGPoint(x: (pointLocation.first?.x)!, y:(pointLocation.first?.y)!))
        areaPath.move(to: myPointLocation.first!)
        for index in 2...myPointLocation.count{
            areaPath.addLine(to: myPointLocation[index - 1])
        }
        areaPath.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = areaPath.cgPath
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        view.layer.addSublayer(shapeLayer)
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(rgb: 0xf45041).cgColor, UIColor.clear.cgColor]
        gradient.mask = shapeLayer
        view.layer.addSublayer(gradient)
        return view
    }
    func createAreaForPointFertility(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        let areaPath = UIBezierPath()
        let linePath = UIBezierPath()
        var myPointLocation = [CGPoint]()
        for index in 1...pointLocation.count{
            if lineChart.dataPoint[index - 1].status == .fertility{
                myPointLocation.append(pointLocation[index - 1])
            }
        }
        linePath.move(to: CGPoint(x: (myPointLocation.first?.x)!, y: 0))
        linePath.addLine(to: CGPoint(x: (myPointLocation.first?.x)!, y: frame.height))
        linePath.move(to: CGPoint(x: (myPointLocation.last?.x)!, y: 0))
        linePath.addLine(to: CGPoint(x: (myPointLocation.last?.x)!, y: frame.height))
        linePath.close()
        let shapeLayerLine = CAShapeLayer()
        shapeLayerLine.path = linePath.cgPath
        shapeLayerLine.strokeColor = UIColor(rgb: 0x42f4aa).cgColor
        shapeLayerLine.lineWidth = 1.0
        view.layer.addSublayer(shapeLayerLine)
        
        myPointLocation.append(CGPoint(x: (myPointLocation.last?.x)!, y:frame.height))
        myPointLocation.append(CGPoint(x: (myPointLocation.first?.x)!, y:frame.height))
        myPointLocation.append(CGPoint(x: (myPointLocation.first?.x)!, y:(myPointLocation.first?.y)!))
        areaPath.move(to: myPointLocation.first!)
        for index in 2...myPointLocation.count{
            areaPath.addLine(to: myPointLocation[index - 1])
        }
        areaPath.close()
        let shapeLayerArea = CAShapeLayer()
        shapeLayerArea.path = areaPath.cgPath
        shapeLayerArea.strokeColor = UIColor.clear.cgColor
        shapeLayerArea.lineWidth = 1.0
        view.layer.addSublayer(shapeLayerArea)
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(rgb: 0x42f4aa).cgColor, UIColor.clear.cgColor]
        gradient.mask = shapeLayerArea
        view.layer.addSublayer(gradient)
        return view
    }
    func createLineForPoints(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        let linePath = UIBezierPath()
        linePath.move(to: pointLocation.first!)
        for index in 2...pointLocation.count{
            linePath.addLine(to: pointLocation[index - 1])
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = linePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1.0
            view.layer.addSublayer(shapeLayer)
        }
        linePath.close()
        return view
    }
    func addDataPoint(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        for index in 1...pointLocation.count{
            let pointPath = UIBezierPath()
            pointPath.addArc(withCenter: pointLocation[index - 1], radius: 3, startAngle: 0, endAngle: .pi*2, clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = pointPath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            if lineChart.dataPoint[index - 1].status == .period{
                shapeLayer.strokeColor = UIColor.red.cgColor
                shapeLayer.fillColor = UIColor.red.cgColor
            }else if lineChart.dataPoint[index - 1].status == .fertility{
                shapeLayer.strokeColor = UIColor(rgb: 0x42f4aa).cgColor
                shapeLayer.fillColor = UIColor(rgb: 0x42f4aa).cgColor
            }else if lineChart.dataPoint[index - 1].status == .PMS{
                shapeLayer.strokeColor = UIColor.magenta.cgColor
                shapeLayer.fillColor = UIColor.magenta.cgColor
            }else if lineChart.dataPoint[index - 1].status == .normal{
                shapeLayer.strokeColor = UIColor.white.cgColor
                shapeLayer.fillColor = UIColor.white.cgColor
            }
            shapeLayer.lineWidth = 1.0
            view.layer.addSublayer(shapeLayer)
        }
        return view
    }
    func calculatLocationPoint(frame: CGRect) -> [CGPoint] {
        var pointList = [CGPoint]()
        let v = frame.width / CGFloat(lineChart.titleHorizontal.count)
        let h = frame.height / CGFloat(lineChart.titleVertical.count)
        var count = lineChart.titleVertical.count - 1
        for index in 1...lineChart.dataPoint.count{
            count -= fundIndexValue(value: lineChart.dataPoint[index - 1].temprecher, in: lineChart.titleVertical)
            let point = CGPoint(x: v * CGFloat(index), y: h * CGFloat(count))
            pointList.append(point)
            count = lineChart.titleVertical.count - 1
        }
        return pointList
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
        pointLocation = calculatLocationPoint(frame: CGRect(x: x, y: y, width: width, height: height))
        view.addSubview(createAreaForPoints(frame: CGRect(x: x, y: y, width: width, height: height)))
        view.addSubview(createAreaForPointFertility(frame: CGRect(x: x, y: y, width: width, height: height)))
        view.addSubview(createLineForPoints(frame: CGRect(x: x, y: y, width: width, height: height)))
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
        pointLocation = calculatLocationPoint(frame: CGRect(x: x, y: y, width: width, height: height))
        view.addSubview(createAreaForPoints(frame: CGRect(x: x, y: y, width: width, height: height)))
        view.addSubview(createAreaForPointFertility(frame: CGRect(x: x, y: y, width: width, height: height)))
        view.addSubview(createLineForPoints(frame: CGRect(x: x, y: y, width: width, height: height)))
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
