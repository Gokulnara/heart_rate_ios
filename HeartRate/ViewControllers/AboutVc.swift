//
//  AboutVc.swift
//  HeartRate
//
//  Created by GOKUL NARA on 4/1/24.
//

import UIKit

class AboutVc: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    
    var isNextEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        
        backbutton.isHidden = true
        
        if isNextEnable == false {
            self.nextButton.isHidden = true
            self.backbutton.isHidden = false
        }
    }

    @IBAction func nextAction(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
