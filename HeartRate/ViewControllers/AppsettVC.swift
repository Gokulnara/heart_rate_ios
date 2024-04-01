//
//  AppsettVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/29/23.
//

import UIKit
import HealthKit

class AppsettVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func healthAction(_ sender: Any) {
        //        if HKHealthStore.isHealthDataAvailable() {
        let healthStore = HKHealthStore()
        let heartRateQuantityType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let allTypes = Set([
            heartRateQuantityType
        ])
        healthStore.requestAuthorization(toShare: nil, read: allTypes) { (result, error) in
            if let error = error {
                // deal with the error
                return
            }
            guard result else {
                // deal with the failed request
                return
            }
            // begin any necessary work if needed
        }
        //        }
    }
    
    @IBAction func profileAction(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        controller.isBackEnable = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func aboutAction(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutVc") as! AboutVc
        controller.isNextEnable = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
