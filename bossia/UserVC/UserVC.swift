//
//  ViewController.swift
//  bossia
//
//  Created by ONUR BOSTAN on 21.07.2023.
//

import UIKit
import Firebase

class UserVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var thumbleImageView: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.delegate = self
        passwordText.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let currentUser = Auth.auth().currentUser
        if currentUser != nil
        {
            self.performSegue(withIdentifier: "toHomeVC", sender: nil)
        }
        
        self.logInButton.layer.cornerRadius = 8
        self.registerButton.layer.cornerRadius = 8
        self.thumbleImageView.layer.borderColor = UIColor.clear.cgColor
        self.thumbleImageView.layer.borderWidth = 1
        self.thumbleImageView.layer.cornerRadius = 16
    }
    
    @objc func handleTap()
    {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    
    @IBAction func logInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != ""
        {
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                    if error != nil
                    {
                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    } else
                    {
                        self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                    }
                }
            } else
        {
                makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
            }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != ""
        {
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                    if error != nil
                    {
                        self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    } else
                    {
                        let fireStoreDB = Firestore.firestore()
                        if let currentUser = Auth.auth().currentUser
                        {
                            let fireStoreUser = ["mail": currentUser.email!, "password": self.passwordText.text!]
                            fireStoreDB.collection("Members").document(currentUser.email!).setData(fireStoreUser) { error in
                                if let error = error
                                {
                                    self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                                } else
                                {
                                    self.makeAlert(titleInput: "Success!", messageInput: "Registered")
                                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                                }
                            }
                        }
                    }
                }
            } else
        {
                makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
            }
    }

    @IBAction func forgotPasswordButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toForgotVC", sender: nil)
    }
    
    
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}

