//
//  SearchVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 17.08.2023.
//

import UIKit
import Firebase

struct User {
    let email : String
}

class SearchVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        searchBar.delegate = self
        
    }
    func searchUsers(query: String) {
            let usersRef = Firestore.firestore().collection("Members")
            usersRef.whereField("mail", isEqualTo: query).getDocuments { (snapshot, error) in
                if let error = error
                {
                    self.makeAlert(titleInput: "Error!", messageInput: error.localizedDescription)
                    return
                }
                self.users = []
                for document in snapshot!.documents {
                    let data = document.data()
                    if let usermail = data["mail"] as? String {
                        let user = User(email: usermail)
                        self.users.append(user)
                    }
                }
                self.tableView.reloadData()
            }
        }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchUsers(query: searchText)
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return users.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
            cell.nameLabel.text = users[indexPath.row].email
            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUserEmail = users[indexPath.row].email
        self.performSegue(withIdentifier: "toMemberVC", sender: selectedUserEmail)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemberVC",
           let memberVC = segue.destination as? MemberVC,
           let selectedUserEmail = sender as? String
        {
            memberVC.selectedUserEmail = selectedUserEmail
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToTabBarVC", sender: nil)
    }
    
    
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
