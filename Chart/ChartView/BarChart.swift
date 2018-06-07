//
//  BarChart.swift
//  Chart
//
//  Created by Amir Sheibani on 6/7/18.
//  Copyright © 2018 amir sheibani. All rights reserved.
//

import UIKit
class BarChart {
    var barChart: StructBarChart!
    var rotationState: RotationState!
    var barChartRightMargin = CGFloat(50)
    var barChartLeftMargin = CGFloat(10)
    var barChartTopMargin = CGFloat(10)
    var barChartDownMargin = CGFloat(50)
    
    var barChartTitle = ""
    var barChartTitleColor = UIColor.clear
    var barLocationLayerOne = [CGPoint]()
    var barLocationLayerTow = [CGPoint]()
    
    var barWidthLayerOne: CGFloat!
    var barWidthLayerTow: CGFloat!
    
    init(barChart: StructBarChart,rotationState: RotationState,barChartTitle: String,barChartTitleColor: UIColor) {
        self.barChartTitle = barChartTitle
        self.barChartTitleColor = barChartTitleColor
        self.barChart = barChart
        self.rotationState = rotationState
    }
    
    func createBarChartMin(frame: CGRect) -> UIView{
        
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        
        var x = barChartRightMargin
        var y = barChartTopMargin
        var width = CGFloat(200)
        var height = CGFloat(30)
        let titel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        titel.center = CGPoint(x: view.frame.size.width / 2, y: height)
        titel.text = barChartTitle
        titel.textAlignment = .center
        titel.font = UIFont(name: titel.font.fontName, size: 18)
        titel.textColor = barChartTitleColor
        view.addSubview(titel)
        
        x = barChartRightMargin
        y = barChartTopMargin
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = (frame.height / 2) - barChartDownMargin
        view.addSubview(createAxis(frame: CGRect(x: x, y: y, width: width, height: height)))
        
        x = barChartRightMargin
        y = barChartTopMargin + 30
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = (frame.height / 2) - barChartDownMargin - 30
        view.addSubview(addDivider(frame: CGRect(x: x, y: y, width: width, height: height),state: .horizontal))
        
        x = barChartRightMargin
        y = barChartTopMargin + 30
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = (frame.height / 2) - barChartDownMargin - 30
        view.addSubview(addDivider(frame: CGRect(x: x, y: y, width: width, height: height),state: .vertical))
        
        x = 0
        y = barChartTopMargin + 30
        width = barChartRightMargin
        height = (frame.height / 2) - barChartDownMargin - 30
        let vertcalLabelFrame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(createAxisLabel(frame: vertcalLabelFrame,state: .vertical))
        
        x = barChartRightMargin
        y = (frame.height / 2) - barChartDownMargin + barChartTopMargin
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = barChartDownMargin
        let horizontalLabelFrame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(createAxisLabel(frame: horizontalLabelFrame,state: .horizontal))
        
        x = barChartRightMargin
        y = barChartTopMargin + 30
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = (frame.height / 2) - barChartDownMargin - 30
        barLocationLayerOne = calculatLocationBarLayerOne(frame: CGRect(x: x, y: y, width: width, height: height))
        barLocationLayerTow = calculatLocationBarLayerTow(frame: CGRect(x: x, y: y, width: width, height: height))
        view.addSubview(drawDataBarLayerOne(frame: CGRect(x: x, y: y, width: width, height: height)))
        view.addSubview(drawDataBarLayerTow(frame: CGRect(x: x, y: y, width: width, height: height)))
//        view.addSubview(createAreaForPoints(frame: CGRect(x: x, y: y, width: width, height: height)))
//        view.addSubview(createAreaForPointFertility(frame: CGRect(x: x, y: y, width: width, height: height)))
//        view.addSubview(createbarForPoints(frame: CGRect(x: x, y: y, width: width, height: height)))
//        view.addSubview(addDataPoint(frame: CGRect(x: x, y: y, width: width, height: height)))
        return view
    }
    
    func createBarChartMax(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        
        var x = barChartRightMargin
        var y = barChartTopMargin
        var width = CGFloat(200)
        var height = CGFloat(30)
        let titel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        titel.center = CGPoint(x: view.frame.size.width / 2, y: height)
        titel.text = barChartTitle
        titel.textAlignment = .center
        titel.font = UIFont(name: titel.font.fontName, size: 18)
        titel.textColor = barChartTitleColor
        view.addSubview(titel)
        
        x = barChartRightMargin
        y = barChartTopMargin
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = frame.height - barChartDownMargin
        view.addSubview(createAxis(frame: CGRect(x: x, y: y, width: width, height: height)))
        
        x = barChartRightMargin
        y = barChartTopMargin + 30
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = frame.height - barChartDownMargin - 30
        view.addSubview(addDivider(frame: CGRect(x: x, y: y, width: width, height: height),state: .horizontal))
        
        x = barChartRightMargin
        y = barChartTopMargin + 30
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = frame.height - barChartDownMargin - 30
        view.addSubview(addDivider(frame: CGRect(x: x, y: y, width: width, height: height),state: .vertical))
        
        x = 0
        y = barChartTopMargin + 30
        width = barChartRightMargin
        height = frame.height - barChartDownMargin - 30
        let vertcalLabelFrame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(createAxisLabel(frame: vertcalLabelFrame,state: .vertical))
        
        x = barChartRightMargin
        y = frame.height - barChartDownMargin + barChartTopMargin
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = barChartDownMargin
        let horizontalLabelFrame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(createAxisLabel(frame: horizontalLabelFrame,state: .horizontal))
        
        x = barChartRightMargin
        y = barChartTopMargin + 30
        width = frame.width - barChartRightMargin - barChartLeftMargin
        height = frame.height - barChartDownMargin - 30
        barLocationLayerOne = calculatLocationBarLayerOne(frame: CGRect(x: x, y: y, width: width, height: height))
        barLocationLayerTow = calculatLocationBarLayerTow(frame: CGRect(x: x, y: y, width: width, height: height))
        view.addSubview(drawDataBarLayerOne(frame: CGRect(x: x, y: y, width: width, height: height)))
        view.addSubview(drawDataBarLayerTow(frame: CGRect(x: x, y: y, width: width, height: height)))
//        view.addSubview(createAreaForPoints(frame: CGRect(x: x, y: y, width: width, height: height)))
//        view.addSubview(createAreaForPointFertility(frame: CGRect(x: x, y: y, width: width, height: height)))
//        view.addSubview(createbarForPoints(frame: CGRect(x: x, y: y, width: width, height: height)))
//        view.addSubview(addDataPoint(frame: CGRect(x: x, y: y, width: width, height: height)))
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
            let h = frame.height / CGFloat(barChart.titleVertical.count)
            for index in (0...barChart.titleVertical.count).reversed(){
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
            let v = frame.width / CGFloat(barChart.titleHorizontal.count)
            for index in 1...barChart.titleHorizontal.count{
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
    func createAxisLabel(frame: CGRect,state: LabelFrameState) -> UIView {
        let view = UIView(frame: frame)
        if state == .vertical{
            view.backgroundColor = UIColor.clear
            let x = CGFloat(0)
            let y = CGFloat(0)
            let width = frame.width
            let height = frame.height / CGFloat(barChart.titleVertical.count)
            
            for index in 1...barChart.titleVertical.count{
                let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
                label.center = CGPoint(x: width/2, y: (height * CGFloat((barChart.titleVertical.count + 1) - index)) - (height/2))
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.text = barChart.titleVertical[index - 1]
                if rotationState == .landscape{
                    label.font = UIFont(name: label.font.fontName, size: 12)
                }else{
                    label.font = UIFont(name: label.font.fontName, size: 12)
                }
                view.addSubview(label)
            }
        }else{
            view.backgroundColor = UIColor.clear
            let x = CGFloat(0)
            let y = CGFloat(0)
            let width = frame.width / CGFloat(barChart.titleHorizontal.count)
            let height = frame.height
            for index in 1...barChart.titleHorizontal.count{
                let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height/2))
                label.center = CGPoint(x: (width *  CGFloat(index)) - (width/2), y: height/3)
                label.textAlignment = .center
                label.textColor = UIColor.white
                label.text = barChart.titleHorizontal[index - 1]
                if rotationState == .landscape{
                    label.font = UIFont(name: label.font.fontName, size: 16)
                }else{
                    label.font = UIFont(name: label.font.fontName, size: 8)
                }
                view.addSubview(label)
            }
        }
        return view
    }
    func calculatLocationBarLayerOne(frame: CGRect) -> [CGPoint] {
        var pointList = [CGPoint]()
        let v = frame.width / CGFloat(barChart.titleHorizontal.count)
        let h = frame.height / CGFloat(barChart.titleVertical.count)
        self.barWidthLayerOne = v
        var count = barChart.titleVertical.count - 1
        for index in 1...barChart.valueDataBarLayerOne.count{
            count -= fundIndexValue(value: barChart.valueDataBarLayerOne[index - 1], in: barChart.titleVertical)
            let point = CGPoint(x: v * CGFloat(index), y: h * CGFloat(count))
            pointList.append(point)
            count = barChart.titleVertical.count - 1
        }
        return pointList
    }
    func calculatLocationBarLayerTow(frame: CGRect) -> [CGPoint] {
        var pointList = [CGPoint]()
        let v = frame.width / CGFloat(barChart.titleHorizontal.count)
        let h = frame.height / CGFloat(barChart.titleVertical.count)
        self.barWidthLayerTow = v
        var count = barChart.titleVertical.count - 1
        for index in 1...barChart.valueDataBarLayerTow.count{
            count -= fundIndexValue(value: barChart.valueDataBarLayerTow[index - 1], in: barChart.titleVertical)
            let point = CGPoint(x: v * CGFloat(index), y: h * CGFloat(count))
            pointList.append(point)
            count = barChart.titleVertical.count - 1
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
    func drawDataBarLayerOne(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        for index in 1...barLocationLayerOne.count{
            let linePath = UIBezierPath()
            let pointOne = CGPoint(x: barLocationLayerOne[index - 1].x - (barWidthLayerOne / 2), y: frame.height)
            linePath.move(to: pointOne)
            let pointTow = CGPoint(x: barLocationLayerOne[index - 1].x - (barWidthLayerOne / 2), y: barLocationLayerOne[index - 1].y)
            linePath.addLine(to: pointTow)
            linePath.close()
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = linePath.cgPath
            shapeLayer.strokeColor = UIColor.orange.cgColor
            shapeLayer.cornerRadius = 8
            shapeLayer.lineWidth = barWidthLayerOne - ((barWidthLayerOne * 20) / 100)
            view.layer.addSublayer(shapeLayer)
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor(rgb: 0x42f4aa).cgColor, UIColor(rgb: 0x25a36e).cgColor]
            gradient.mask = shapeLayer
            
            view.layer.addSublayer(gradient)
        }
        return view
    }
    func drawDataBarLayerTow(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        for index in 1...barLocationLayerTow.count{
            let linePath = UIBezierPath()
            let pointOne = CGPoint(x: barLocationLayerTow[index - 1].x - (barWidthLayerTow / 2), y: frame.height)
            linePath.move(to: pointOne)
            let pointTow = CGPoint(x: barLocationLayerTow[index - 1].x - (barWidthLayerTow / 2), y: barLocationLayerTow[index - 1].y)
            linePath.addLine(to: pointTow)
            linePath.close()
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = linePath.cgPath
            shapeLayer.strokeColor = UIColor(rgb: 0xf70733).cgColor
            shapeLayer.cornerRadius = 8
            shapeLayer.lineWidth = barWidthLayerTow - ((barWidthLayerTow * 25) / 100)
            view.layer.addSublayer(shapeLayer)
        }
        return view
    }
}
