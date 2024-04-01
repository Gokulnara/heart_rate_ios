//
//  SignuVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/29/23.
//

import UIKit

class SignuVC: UIViewController {
    
    @IBOutlet weak var sighUpButton: UIButton!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    var signupModel: LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        usernameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        
        sighUpButton.layer.cornerRadius = sighUpButton.layer.frame.size.height / 2
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        signUpAPI()
    }
    
    func signUpAPI(){
        guard let username = usernameTF.text else {return}
        guard let email = emailTF.text else {return}
        guard let password = passwordTF.text else {return}
        guard let confirmPassword = confirmPasswordTF.text else {return}
        
        let formData = ["username":username, "email":email, "password":password, "confirm_password":confirmPassword]
        
        APIHandler.shared.postAPIValues(type: LoginModel.self, apiUrl: Constant.signupURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let response):
                print(response)
                self.signupModel = response
                DispatchQueue.main.async {
                    if response.status == "Success"{
                        let nextVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutYouVC") as! AboutYouVC
                        nextVc.id = self.signupModel?.userID ?? ""
                        UserDefaults.standard.setValue(self.signupModel?.userID, forKey: "ID")
                        self.navigationController?.pushViewController(nextVc, animated: true)
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

extension SignuVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

