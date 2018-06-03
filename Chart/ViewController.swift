//
//  ViewController.swift
//  Chart
//
//  Created by amir sheibani on 6/3/18.
//  Copyright © 2018 amir sheibani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var chartView: ChartView!
    
    
    var titleHorizontalBar = ["اسفند","بهمن","دی","آذر","آبان","مهر","شهریور","مرداد","تیر","خرداد","اردیبهشت","فروردین"]
    var titleVerticalBar = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"]
    var valueDataBarLayerOneBar = [28,25,26,27,28,27,26,25,25,15,18,24]
    var valueDataBarLayerTowBar = [5,5,4,5,5,6,6,6,6,5,5,6]
    
    var titleHorizontalLine = [String]()
    var titleVerticalLine = [String]()
    var dataPointLine = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            let orient = UIApplication.shared.statusBarOrientation
            switch orient {
            case .portrait:
                self.chartView.viewUpdate()
                print("Portrait")
                
            case .landscapeLeft,.landscapeRight :
                self.chartView.viewUpdate()
                print("Landscape")
                
            default:
                
                print("Anything But Portrait")
            }
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
        })
        super.viewWillTransition(to: size, with: coordinator)
    }

}
extension ViewController: ChartDelegate{
    func chartData() -> [ChartType : Any] {
        var v = [ChartType : Any]()
        var structBareChart = StructBarChart()
        structBareChart.titleHorizontal = self.titleHorizontalBar
        structBareChart.titleVertical = self.titleVerticalBar
        structBareChart.valueDataBarLayerOne = self.valueDataBarLayerOneBar
        structBareChart.valueDataBarLayerTow = self.valueDataBarLayerTowBar
        var structPieChart = StructPieChart()
        structPieChart.totalCount = 30
        structPieChart.itemsValue = ["good" : 5,"bad" : 10,"derty": 15]
        structPieChart.itemsColor = [UIColor.red,UIColor.cyan,UIColor.green]
        var structLineChart = StructLineChart()
//        for index in 1...28{
//            titleHorizontalLine[index-1] = "\(index)"
//        }
        titleHorizontalLine = titleHorizontalBar
        dataPointLine =  [37,36,37,38,39,40,41,40,39,36,37,36,37,38,39,40,41,40,39,36,37,36,37,38,39,40,41,40]
        titleVerticalLine = ["36","37","38","39","40","41","42"]
        structLineChart.titleHorizontal = titleHorizontalLine
        structLineChart.dataPoint = dataPointLine
        structLineChart.titleVertical = titleVerticalLine
        
        v[.line] = structLineChart
        v[.pie] = structPieChart
        v[.bar] = structBareChart
        return v
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

