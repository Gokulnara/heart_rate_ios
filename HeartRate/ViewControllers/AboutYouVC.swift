//
//  MaleVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/29/23.
//

import UIKit

class AboutYouVC: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    
    var gender = String()
    var id: String = String()
    var details: PostStringModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        continueButton.layer.cornerRadius = continueButton.layer.frame.size.height / 2
        
        genderImageView.image = .male
        
        gender = "Male"
        
        ageTF.delegate = self
        heightTF.delegate = self
        weightTF.delegate = self
    }
   
    @IBAction func continueAction(_ sender: Any) {
        detailsAPI()
    }
    
    @IBAction func segmentAction(_ sender: Any) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            genderImageView.image = .male
            gender = "Male"
        case 1:
            genderImageView.image = .female
            gender = "Female"
        case 2:
            genderImageView.image = .others
            gender = "Others"
        default:
            break
        }
    }
    
    func detailsAPI() {
        guard let age = ageTF.text else {return}
        guard let height = heightTF.text else {return}
        guard let weight = weightTF.text else {return}
        
        let formData = ["id":id, "gender":gender, "age":age, "height":height, "weight": weight]
        
        APIHandler.shared.postAPIValues(type: PostStringModel.self, apiUrl: Constant.detailsURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let response):
                print(response)
                self.details = response
                DispatchQueue.main.async {
                    if response.status == "Success" {
                        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let alert = UIAlertController(title: response.status, message: response.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
}

extension AboutYouVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
