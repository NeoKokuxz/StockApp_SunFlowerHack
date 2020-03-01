//
//  HomeViewController.swift
//  StockApp
//
//  Created by Naoki on 2/24/20.
//  Copyright © 2020 Naoki. All rights reserved.
//

import UIKit
import Charts

//MARK: - HomeViewController
class HomeViewController: UIViewController, ChartViewDelegate {
    
    var stockManager = StockManager()

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var stockOwns: UILabel!
    @IBOutlet weak var stockBuyNum: UITextField!
    @IBOutlet weak var stockSellNum: UITextField!
    
    
    var nameNow = "";
    var priceNow = "";
    
    //    var dailyLineChartEntry = [ChartDataEntry]()
//    var weeklyLineChartEntry = [ChartDataEntry]()
//    var monthlyLineChartEntry = [ChartDataEntry]()
//    var yearlyLineChartEntry = [ChartDataEntry]()
    
    var shouldHideData: Bool = false
    
    
    let x = 50;
    let y = 50;
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chartView.delegate = self
        stockBuyNum.delegate = self

        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        
        chartView.leftAxis.enabled = true
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        chartView.legend.form = .line
        
        chartView.animate(xAxisDuration: 1)
        hoursInDay()
        
        stockName.text = nameNow
        priceLabel.text = priceNow
        
    }
    
    func getNumber() -> Int {
        let number = Int.random(in: 3 ..< 10)
        return number
    }
    
    func leftAxisLimit(max: Int, min: Int){
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
//        leftAxis.addLimitLine(max)
//        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = Double(max)
        leftAxis.axisMinimum = Double(min)
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
    }
    
//    func rightAxisLimit() {
//
//    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func DBtn(_ sender: UIButton) {
        hoursInDay()
        chartView.animate(xAxisDuration: 1)
    }
    
    
    @IBAction func WBtn(_ sender: UIButton) {
        daysInWeek()
        chartView.animate(xAxisDuration: 1)

    }
    
    @IBAction func MBtn(_ sender: UIButton) {
        daysInMonth()
        chartView.animate(xAxisDuration: 1)


    }
    
    @IBAction func YBtn(_ sender: UIButton) {
        monthsInYear()
        chartView.animate(xAxisDuration: 1)
    }
    
    func fill(){
        //Fill Function
        for set in chartView.data!.dataSets as! [LineChartDataSet] {
            set.drawFilledEnabled = !set.drawFilledEnabled
        }
    }
    
    func hoursInDay() {
        let hour = 24;
        var dailyLineChartEntry = [ChartDataEntry]()
        for i in 1...24 {
            if(i%2 == 0){
                let y = getNumber()
                let value = ChartDataEntry(x: Double(i), y: Double(y))
                dailyLineChartEntry.append(value)
            }
        }
        leftAxisLimit(max: hour + 1, min: 1)
        
        let line1 = LineChartDataSet(entries: dailyLineChartEntry, label: "24 Hours")
        line1.lineWidth = 3
        line1.circleRadius = 3
        line1.drawCircleHoleEnabled = false
        let data = LineChartData()
        data.addDataSet(line1)
        chartView.xAxis.labelPosition = .bottom
        chartView.data = data
        chartView.chartDescription?.text = "Daily"
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        self.updateChartData()

    }
    
    func daysInWeek() {
        let day = 7;
        var weeklyLineChartEntry = [ChartDataEntry]()
        for i in 1...7 {
            let y = getNumber()
            let value = ChartDataEntry(x: Double(i), y: Double(y))
            weeklyLineChartEntry.append(value)
        }
        leftAxisLimit(max: day + 5, min: 1)
        let line2 = LineChartDataSet(entries: weeklyLineChartEntry, label: "7 Days")
        line2.lineWidth = 3
        line2.circleRadius = 3
        let data = LineChartData()
        chartView.xAxis.labelPosition = .bottom
        data.addDataSet(line2)
        chartView.data = data
        chartView.chartDescription?.text = "Weekly"
        self.updateChartData()
    }
    
    func daysInMonth() {
        let month = 31;
        var monthlyLineChartEntry = [ChartDataEntry]()

        chartView.resetZoom()
        //Depends on month differences
        for i in 1...31 {
            if(i%2==0){
                let y = getNumber()
                let value = ChartDataEntry(x: Double(i), y: Double(y))
                monthlyLineChartEntry.append(value)
            }
        }
        
        leftAxisLimit(max: month + 1, min: 1)

        //Change base on days in that specific month
        let line3 = LineChartDataSet(entries: monthlyLineChartEntry, label: "30 Days")
        line3.lineWidth = 3
        line3.circleRadius = 3
        let data = LineChartData()
        chartView.xAxis.labelPosition = .bottom
        data.addDataSet(line3)
        chartView.data = data
        chartView.chartDescription?.text = "Monthly"
        chartView.resetZoom()
        self.updateChartData()
    }
    func monthsInYear() {
        let year = 12;
        var yearlyLineChartEntry = [ChartDataEntry]()

        for i in 1...12 {
            let y = getNumber()
            let value = ChartDataEntry(x: Double(i), y: Double(y))
            yearlyLineChartEntry.append(value)
        }
        
        leftAxisLimit(max: year + 1, min: 1)
        
        let line4 = LineChartDataSet(entries: yearlyLineChartEntry, label: "12 Months")
        line4.lineWidth = 3
        line4.circleRadius = 3
        let data = LineChartData()
        chartView.xAxis.labelPosition = .bottom
        data.addDataSet(line4)
        chartView.data = data
        chartView.chartDescription?.text = "Yearly"
        self.updateChartData()
    }
    
    func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
//        self.setDataCount(Int(x), range: UInt32(y))
    }
    
    
    
    //MARK: - Buy Stock
    
    @IBAction func buyBtn(_ sender: UIButton) {
        hoursInDay()
        chartView.animate(xAxisDuration: 1)
        buyStock()
    }
    
    func buyStock(){
        let getAsset = assetLabel.text!
        let num = stockBuyNum.text!
        let getOwnsNum = stockOwns.text!
        var cost = 0.0
//        let cost = Int(priceLabel.text!) * num
        print(getAsset)
        print(num)
        
        let getPrice = priceLabel.text!
        
        if stockBuyNum.text != nil {
            cost = Double(num)! * Double(getPrice)!
        }
        
        if (Double(getAsset)! >= cost) {
            let balance = Double(getAsset)! - cost
            assetLabel.text = String(format: "%.2f", balance)
            let newOwnNum = Int(num)! + Int(getOwnsNum)!
            stockOwns.text = String(newOwnNum)
        }
        
        stockBuyNum.text = ""
        
    }
    
    //MARK: - Sell Stock
    
    @IBAction func sellBtn(_ sender: UIButton) {
        hoursInDay()
        chartView.animate(xAxisDuration: 1)
        sellStock()
    }
    func sellStock(){
            //get asset
            let getAsset = assetLabel.text!
            //how many to sell
            let num = stockSellNum.text!
            //how many owned
            let getOwnsNum = stockOwns.text!
            var earning = 0.0
    //        let cost = Int(priceLabel.text!) * num
            print(getAsset)
            print(num)
            
            //get current price
            let getPrice = priceLabel.text!
            
            
            if stockSellNum.text != nil {
                earning = Double(num)! * Double(getPrice)!
            }
            
            if (Int(getOwnsNum)! >= Int(num)!) {
                let balance = Double(getAsset)! + earning
                assetLabel.text = String(format: "%.2f", balance)
                let newOwnNum = Int(getOwnsNum)! - Int(num)!
                stockOwns.text = String(newOwnNum)
            }
            
            stockSellNum.text = ""
            
        }
}

//MARK: - TextField
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //dismisskeyboard
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "0"
            return true
        }
    }
    
//    //Clear textfield when done typing
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        stockBuyNum.text = ""
//    }
    
}
    
//    func setDataCount(_ count: Int, range: UInt32) {
//        let values = (0..<count).map { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 3)
//            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
//        }
//
//        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
//        set1.drawIconsEnabled = false
//
//        set1.lineDashLengths = [5, 2.5]
//        set1.highlightLineDashLengths = [5, 2.5]
//        set1.setColor(.black)
//        set1.setCircleColor(.black)
//        set1.lineWidth = 1
//        set1.circleRadius = 3
//        set1.drawCircleHoleEnabled = false
//        set1.valueFont = .systemFont(ofSize: 9)
//        set1.formLineDashLengths = [5, 2.5]
//        set1.formLineWidth = 1
//        set1.formSize = 15
//
//        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
//                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//        set1.fillAlpha = 1
//        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//        set1.drawFilledEnabled = true
//
//        let data = LineChartData(dataSet: set1)
//
//        chartView.data = data
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
