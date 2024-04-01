//
//  HomeVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/18/23.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var guidelineView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        continueButton.layer.cornerRadius = continueButton.layer.frame.size.height / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startAction))
        startView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.guidelineView.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func ContinueAction(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PulseMeasureVC") as! PulseMeasureVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.guidelineView.isHidden = true
    }
    
    @objc func startAction(){
        self.guidelineView.isHidden = false
    }
}
