//
//  ResultVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/29/23.
//

import UIKit
import AVFoundation

class ResultVC: UIViewController {
    
    @IBOutlet weak var pulseLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var resultValue = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        doneButton.layer.cornerRadius = doneButton.layer.frame.size.height / 2
        
        if resultValue >= 65 && resultValue <= 120 {
            levelLabel.text = "GOOD"
        } else if resultValue < 65 {
            levelLabel.text = "LOW"
        } else {
            levelLabel.text = "HIGH"
        }
        
        pulseLabel.text = String(resultValue)
//        levelLabel.text = "Good"
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        pulseAPI()
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: TabBarViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func pulseAPI() {
        guard let id = UserDefaults.standard.value(forKey: "ID") as? String else {return}
        guard let pulse = pulseLabel.text else {return}
        guard let level = levelLabel.text else {return}
        
        let formData = ["id":id, "pulse":pulse, "level":level]
        
        APIHandler.shared.postAPIValues(type: PostStringModel.self, apiUrl: Constant.pulseSaveURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
}
