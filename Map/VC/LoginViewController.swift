//
//  LoginViewController.swift
//  Map
//
//  Created by مي الدغيلبي on 13/03/1441 AH.
//  Copyright © 1441 مي الدغيلبي. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var udacityLogo: UIImageView!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
   @IBOutlet weak var signUp: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
       
    }
    
    

    @IBAction func loginClick(_ sender: Any) {
        
        API.login(username: EmailTextField.text!, password: PasswordTextField.text!) { (errString) in
            guard errString == nil else {
                self.showAlert(title: "Error", message: errString!)
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginID", sender: nil)
            }
        }
    }
        
    
    override func  prepare(for segue: UIStoryboardSegue,
                           sender: Any?){
        if segue.identifier == "loginID" {
            _ = segue.destination as! UITabBarController
        }
        
    }
    
        
       @IBAction func SignUpClick(_ sender: Any) {
 
 if let url = URL(string: "https://auth.udacity.com/sign-up") {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
 }
    }

}//end class



//Exstention
   extension LoginViewController:UITextFieldDelegate
    {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

