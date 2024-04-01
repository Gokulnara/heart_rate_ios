//
//  ProfileVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/29/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var profileModel: ProfileModel?
    var isBackEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backButton.isHidden = true
        
        if isBackEnable == true {
            self.backButton.isHidden = false
        }
        
        profileAPI()
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func profileAPI() {
        guard let id = UserDefaults.standard.value(forKey: "ID") as? String else {return}
        
        let formData = ["id":id]
        
        APIHandler.shared.postAPIValues(type: ProfileModel.self, apiUrl: Constant.profileURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let response):
                print(response)
                self.profileModel = response
                DispatchQueue.main.async {
                    self.usernameLabel.text = "-     \(self.profileModel?.details?.first?.username ?? "")"
                    self.emailLabel.text = "-     \(self.profileModel?.details?.first?.email ?? "")"
                    self.ageLabel.text = "-     \(self.profileModel?.details?.first?.age ?? "") Yrs"
                    self.heightLabel.text = "-     \(self.profileModel?.details?.first?.height ?? "") cm"
                    self.weightLabel.text = "-     \(self.profileModel?.details?.first?.weight ?? "") kg"
                    self.genderLabel.text = "-     \(self.profileModel?.details?.first?.gender ?? "")"
                }
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
}
