//
//  LoginVC.swift
//  HeartRate
//
//  Created by GOKUL NARA on 12/18/23.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var loginModel: LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loginButton.layer.cornerRadius = loginButton.layer.frame.size.height / 2
        
        self.usernameTF.delegate = self
        self.passwordTF.delegate = self
    }
    
    @IBAction func loginAction(_ sender: Any) {
        loginAPI()
//        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignuVC") as! SignuVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func loginAPI() {
        guard let username = usernameTF.text else {return}
        guard let password = passwordTF.text else {return}
        
        let formData = ["username":username, "password":password]
        
        APIHandler.shared.postAPIValues(type: LoginModel.self, apiUrl: Constant.loginURL, method: "POST", formData: formData) { result in
            switch result {
            case .success(let response):
                print(response)
                self.loginModel = response
                DispatchQueue.main.async {
                    if response.status == "Success"{
                        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                        UserDefaults.standard.setValue(self.loginModel?.userID, forKey: "ID")
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
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    
}
    
extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
