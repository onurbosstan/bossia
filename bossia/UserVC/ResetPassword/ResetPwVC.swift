//
//  ResetPwVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 15.08.2023.
//

import UIKit
import Firebase

class ResetPwVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    @IBAction func resetPasswordButtonClicked(_ sender: Any) {
     
        guard let email = emailTextField.text, !email.isEmpty else {
            self.makeAlert(titleInput: "Error!", messageInput: "Email not found!")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
            } else {
                self.makeAlert(titleInput: "Succes!", messageInput: "Password reset sent!")
            }
        }
        
    }
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
