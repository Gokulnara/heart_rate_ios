//
//  WeekVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/29/23.
//

import UIKit

class WeekVC: UIViewController {
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date = String()
    var pulseModel: PulseModel?
    var lineChartView: LineChartView!
    var isInitialDate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        lineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height))
        //        lineChartView.showGrid = true
        //        lineChartView.backgroundColor = UIColor.white
        
        //        let dataset: (dataPoints: [CGFloat], color: UIColor) = ([10,20,30,40], UIColor.red)
        //        lineChartView.datasets = [dataset]
        
        // Sample x-axis and y-axis labels
        //        let xLabels: [String] = ["10", "20", "40", "60", "80", "100"]
        //        let yLabels: [String] = ["0", "20", "40", "60", "80"]
        //        
        //        lineChartView.xLabels = xLabels
        //        lineChartView.yLabels = yLabels
        //        
        //        // Add the LineChartView to the view hierarchy
        //        self.chartView.addSubview(lineChartView)
        
        setupDatePicker()
        
        let initialDate = datePicker.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd" // Use the appropriate format
        let formattedDate = dateFormat.string(from: initialDate)
        pulseAPI(date: formattedDate)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AppsettVC") as! AppsettVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.date = .now
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if isInitialDate {
            isInitialDate = false
            return
        }
        let selectedDate = sender.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd" // Use the appropriate format
        let formattedDate = dateFormat.string(from: selectedDate)
        pulseAPI(date: formattedDate)
    }
    
    func pulseAPI(date: String) {
        guard let id = UserDefaults.standard.value(forKey: "ID") as? String else {return}
        let formData = ["id":id, "date":date]
        
        APIHandler.shared.postAPIValues(type: PulseModel.self, apiUrl: Constant.pulseDetailsURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let response):
                print(response)
                self.pulseModel = response
                DispatchQueue.main.async {
                    self.lineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: self.chartView.frame.width, height: self.chartView.frame.height))
                    self.lineChartView.showGrid = true
                    self.lineChartView.backgroundColor = UIColor.white
                    
                    let data = self.pulseModel?.pulses
                    print("PulseModelValues ::::: \(data)")
                    
                    // Convert the array of strings to an array of CGFloat
                    let dataPoints = data?.compactMap { CGFloat(Double($0) ?? 0) } ?? []
                    
                    let dataset: (dataPoints: [CGFloat], color: UIColor) = (dataPoints, UIColor.red)
                    self.lineChartView.datasets = [dataset]
                    
                    let xLabels: [String] = [""]
                    let yLabels: [String] = ["bpm", "30", "50", "70", "90", "110"]
                    
                    self.lineChartView.xLabels = xLabels
                    self.lineChartView.yLabels = yLabels
                    
                    // Add the LineChartView to the view hierarchy
                    self.chartView.addSubview(self.lineChartView)
                    
                }
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
}
