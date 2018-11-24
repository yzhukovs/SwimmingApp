//
//  ViewController.swift
//  Converter
//
//  Created by Yvette Zhukovsky on 11/20/18.
//  Copyright © 2018 Yvette Zhukovsky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var finalLabel: UILabel!
    
    
    @IBOutlet weak var enterTime: UITextField!
    
    @IBAction func convert(_ sender: Any) {
    
        
        guard let t = parseTime(enteredTime: enterTime.text ?? "") else {return}
        NSLog("t = \(t)")
        guard let time = getTime(t:t) else {return}
        NSLog("time = \(time)")
        let conv = time.course.converter()
        guard let newTime = conv(time.time, time.distance, time.stroke) else {return}
        finalLabel?.text = formatTime(time: newTime)
        
    
    }
    
//    class TimeTextField: UITextField {
//        required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//            registerForNotifications()
//        }
//        
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            registerForNotifications()
//        }
//        
//        private func registerForNotifications() {
//            NotificationCenter.default.addObserver(self, selector: Selector(("textDidChange")), name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: self)
//        }
//        
//        deinit {
//            NotificationCenter.default.removeObserver(self)
//        }
//    }
//    
//    var formattingPattern = "**:**.*"
//    var replacementChar: Character = "*"
//    
    
    
   
    private let dataSource: [[String]] = [
        [Stroke.Backstroke.rawValue, Stroke.Breaststroke.rawValue, Stroke.Butterfly.rawValue, Stroke.Freestyle.rawValue, Stroke.IM.rawValue],
        [ Distance._50.asString(), Distance._100.asString(), Distance._200.asString()],
        [Course.LCM.rawValue, Course.SCY.rawValue]
    ]
    
    private let componentStroke = 0
    private let componentDistance = 1
    private let componentCourse = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style.dataSource = self
        style.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBOutlet weak var style: UIPickerView!
    
    
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource[component].count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func getTime(t: Double) -> Time? {
        guard let stroke: Stroke = Stroke.fromString(s: dataSource[componentStroke][style.selectedRow(inComponent: componentStroke)]),
            let distance: Distance = Distance.fromString(n: dataSource[componentDistance][style.selectedRow(inComponent: componentDistance)]),
            let course: Course = Course.fromString(s: dataSource[componentCourse][style.selectedRow(inComponent: componentCourse)]) else {return nil}
     
        return Time(stroke: stroke, distance: distance, course: course, time: t)
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[component][row]
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let titleData = dataSource[component][row]
//        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Pacifico", size: 12.0)!,NSAttributedString.Key.foregroundColor:UIColor.blue])
//        return myTitle
//
//    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(dataSource[component].count)
            finalLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = dataSource[component][row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
        pickerLabel?.attributedText = myTitle
        pickerLabel?.textAlignment = .center

        return pickerLabel!

    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    
    
    
    
}
