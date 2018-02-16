//
//  StatusDetailViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/25.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
import Charts

class StatusDetailViewController: UIViewController {
    @IBOutlet weak var myChartView: LineChartView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var DetailSegment: UISegmentedControl!
    @IBOutlet weak var DetailRealtimeView: UIView!
    @IBOutlet weak var DetailHistoryView: UIView!
    var tagsList : [String] = []
    private var linechartData = LineChartData()
    var equipIndex :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DetailSegment.selectedSegmentIndex = 0
        let item = UIBarButtonItem(title: "Custome", style: .plain, target: self, action: #selector(self.customeList))
        self.navigationItem.rightBarButtonItem = item
        displayValues()
    }
    
    func setTagList(source : [String]){
        self.tagsList = source
    }
    
    private func displayValues(){
        self.initCurrentValues(values: equipmentList[equipIndex])
        self.drawLinePlot()
        //self.initHistoryValues(values: equipmentList[equipIndex])
    }
    private func initHistoryValues(values:EquipmentInfo){
        ewon.getTagHistory(startTime: "01022018_075000", endTime: "01022018_085000", deviceIndex: 1, completion: self.parseCsv(string:deviceIndex:))
        //ewon.getTagHistory(startTime: "0", endTime: "m1", deviceIndex: 1, completion: {})
    }
    
    func parseCsv(string:String, deviceIndex:Int) {
        let myParser = CsvParser()
        myParser.parseFor = .history
        let result = myParser.parseString(stringData: string)
        equipmentList[deviceIndex].tagsHistory = result
        drawLinePlot()
    }
    
    private func convertDateToString(date:Date) ->String {
        let dtFormat = DateFormatter()
        dtFormat.dateFormat = "ddMMyyyy_HHmmss"
        return dtFormat.string(from:date)
    }
    private func initCurrentValues(values:EquipmentInfo){
        
    }
    private func drawLinePlot(){
        myChartView.clear()
        var dataEntrySet: [ChartDataEntry] = []
        var lineSet : [LineChartDataSet] = []
        let myColors:[NSUIColor] = [NSUIColor.red,NSUIColor.cyan,NSUIColor.green,NSUIColor.black]
    var index = 0;
        for temp in equipmentList[equipIndex].tagsHistory {
            dataEntrySet.removeAll()
            for i in stride(from: 0, to: temp.value.count - 1, by: 2){
                let dataEntryTemp = ChartDataEntry(x: Double(temp.value[i])!, y: Double(temp.value[i + 1])!)
                dataEntrySet.append(dataEntryTemp)
            }
            let line = LineChartDataSet(values: dataEntrySet, label: temp.key)
            line.colors = [myColors[index]]
            line.drawCirclesEnabled = false
            
            index += 1
            if (index > equipmentList[equipIndex].tagsHistory.count - 1) {
                index -= 1
            }
            lineSet.append(line)
        }
        let lineData = LineChartData(dataSets: lineSet)
        myChartView.data = lineData
        let myFormat = StatusDetailChartFormat()
        myChartView.xAxis.valueFormatter = myFormat
        myChartView.animate(xAxisDuration: 3)
    }
    @objc func customeList(){
        let customeVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomeDetail") as! StatusDetailCustomeViewController
        customeVC.deviceIndex = self.equipIndex
        customeVC.parentVC = self
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(customeVC, animated: true)
    }
    
    @IBAction func TapSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.DetailHistoryView.isHidden = true
            self.DetailRealtimeView.isHidden = false
            break
        case 1:
            self.DetailHistoryView.isHidden = false
            self.DetailRealtimeView.isHidden = true
            break
        default:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailRealtime") {
            if let realtimeVc = segue.destination as? StatusDetailRealtimeViewController {
                realtimeVc.deviceIndex = self.equipIndex
                realtimeVc.tagsLabels = self.tagsList
            }
        }
        else if (segue.identifier == "DetailToCustome") {
            if let customeVc = segue.destination as? StatusDetailCustomeViewController {
                customeVc.deviceIndex = self.equipIndex
            }
        }
    }
}

