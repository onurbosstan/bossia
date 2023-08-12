//
//  ChangePasswordVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 12.08.2023.
//

import UIKit
import Firebase

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var currentPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var newPasswordAgainText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func changePassword(currentPassword: String, newPassword: String) {
        guard let currentUser = Auth.auth().currentUser else {
            self.makeAlert(titleInput: "Error!", messageInput: "The user has not registered.")
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: currentPassword)
        currentUser.reauthenticate(with: credential) { (authResult, error) in
            if let error = error
            {
                self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                return
            }
            currentUser.updatePassword(to: newPassword) { (error) in
                if let error = error {
                    self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                    return
                }
                self.makeAlert(titleInput: "Succes!", messageInput: "Password updated successfully.")
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toChangeTab", sender: nil)
    }
    
    
    @IBAction func changePasswordButtonClicked(_ sender: Any)
    {
        guard let currentPassword = currentPasswordText.text,
              let newPassword = newPasswordText.text,
              let newPassowrdAgain = newPasswordAgainText.text,
              newPassword == newPassowrdAgain else {
            self.makeAlert(titleInput: "Error!", messageInput: "Passwords do not match or there is missing information.")
            return
        }
        changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
    
    
    
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK!", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
