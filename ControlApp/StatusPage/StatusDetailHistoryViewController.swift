//
//  StatusDetailHistoryViewController.swift
//  ControlApp
//
//  Created by Jue Wang on 2018/1/31.
//  Copyright © 2018年 AlfaLavalNiagaraBlowers. All rights reserved.
//

import UIKit
class StatusDetailHistoryViewController:UIViewController,UITextFieldDelegate {
    @IBOutlet weak var TF_StartTime: UITextField!
    @IBOutlet weak var TF_EndTime: UITextField!
    @IBOutlet weak var TV_RawResult: UITextView!
    @IBOutlet weak var HistoryLoading:UIActivityIndicatorView!
    private var dateST:Date = Date()
    private var dateET:Date = Date()
    private var picker:UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        setContent()
        TV_RawResult.text = ""
    }
    /// Submit the request to ewon
    @IBAction func TapRetrieve(_ sender: UIButton) {
        HistoryLoading.startAnimating()
        let me = self.parent as! StatusDetailViewController
        let interval1 = Double(dateST.timeIntervalSince1970)
        let interval2 = Double(dateET.timeIntervalSince1970)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMYYYY_HHmmss"
        var stTime = dateFormatter.string(from: dateST)
        var etTime = dateFormatter.string(from: dateET)
        if (interval1 > interval2) {
            swap(&stTime, &etTime)
        }
        ewon.getTagHistory(startTime: stTime, endTime: etTime, deviceIndex: me.equipIndex, completion:self.historyRetrieveCompletion(string:deviceIndex:))
    }
    private func historyRetrieveCompletion(string: String, deviceIndex: Int) {
        HistoryLoading.stopAnimating()
        var content = ""
        let me = self.parent as! StatusDetailViewController
        me.parseCsv(string: string, deviceIndex: deviceIndex)

        if (me.equipIndex < equipmentList.count - 1) {
            return
        }
        for (key,value) in equipmentList[me.equipIndex].tagsHistory {
            content += "\n\(key)\n"
            for i in stride(from: 0, to: value.count - 1, by: 2) {
                let timeStr = timeIntervalToString(interval: Double(value[i])!)
                content += "Date: \( timeStr)    Value: \(value[i + 1])\n"
            }
        }
        TV_RawResult.text = content
    }
    
    private func timeIntervalToString(interval:Double) ->String {
        let timeStamp = Double(interval)
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        return dformatter.string(from: date)
    }
    private func setContent(){
        picker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        picker.datePickerMode = .dateAndTime
        picker.backgroundColor = UIColor.white

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.setTimeLabel1))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.retreatPicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton1], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = .default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar2.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.setTimeLabel2))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.retreatPicker))
        toolBar2.setItems([cancelButton2, spaceButton2, doneButton2], animated: false)
        toolBar2.isUserInteractionEnabled = true
        
        self.TF_StartTime.delegate = self
        self.TF_EndTime.delegate = self
        
        self.TF_StartTime.inputView = picker
        self.TF_StartTime.inputAccessoryView = toolBar
        self.TF_EndTime.inputView = picker
        self.TF_EndTime.inputAccessoryView = toolBar2
        
    }
    
    @objc private func setTimeLabel1(){
        dateST = picker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        self.TF_StartTime.text = dateFormatter.string(from: picker.date)
        self.TF_StartTime.resignFirstResponder()
    }
    @objc private func setTimeLabel2(){
        dateET = picker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        self.TF_EndTime.text = dateFormatter.string(from: picker.date)
        self.TF_EndTime.resignFirstResponder()
    }
    @objc private func retreatPicker() {
        self.TF_StartTime.resignFirstResponder()
        self.TF_EndTime.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.retreatPicker()
    }
}
