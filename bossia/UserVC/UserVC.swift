//
//  ViewController.swift
//  bossia
//
//  Created by ONUR BOSTAN on 21.07.2023.
//

import UIKit
import Firebase

class UserVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var buttonShowPass: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailText.delegate = self
        passwordText.delegate = self
        
        let fireStoreDB = Firestore.firestore()
        fireStoreDB.collection("User").whereField("mail", isEqualTo: emailText.text!).getDocuments { (snapshot, error) in
            if error != nil
            {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            } else
            {
                for document in snapshot!.documents
                {
                    let mail = document.get("mail")
                    print(mail!)
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    @IBAction func logInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""
        {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil
                {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                }else
                {
                    
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
            }
        }else
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
                    let fireStoreUser = ["mail" : Auth.auth().currentUser!.email!, "password": self.passwordText.text!] as? [String : Any]
                    fireStoreDB.collection("User").addDocument(data: fireStoreUser!) { (error) in
                        if error != nil
                        {
                            self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                        } else
                        {
                            self.makeAlert(titleInput: "Success!", messageInput: "Success!")
                        }
                    }
                    
                    self.makeAlert(titleInput: "Successful", messageInput: "Registered")
                    self.performSegue(withIdentifier: "toHomeVC", sender: nil)
                }
            }
        } else
        {
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
        }

    }
    
    @IBAction func actionShow(_ sender: Any)
    {
        if buttonShowPass.titleLabel?.text == "Show"
        {
            buttonShowPass.setTitle("Hide", for: .normal)
            passwordText.isSecureTextEntry = true
        }else
        {
            buttonShowPass.setTitle("Show", for: .normal)
            passwordText.isSecureTextEntry = false
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

