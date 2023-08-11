//
//  SettingsVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 9.08.2023.
//


import UIKit
import Firebase

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    let items: [[(title: String, image: String, color: UIColor?)]] = [
        [
            (title: "Edit Profile", image: "person.fill", color: UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0)),
            (title: "Change Password", image: "lock.fill", color: UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)),
        ],
        [
            (title: "Favorites Posts", image: "star.fill", color: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)),
            
            
        ],
        [(title: "Logout", image: "rectangle.portrait.and.arrow.right", color: .red)]
    ]
    
    /*
    let settingsData = [
            ("Profile Edit", "person.fill"),
            ("Bildirimler", "bildirim_icon"),
            ("Gizlilik", "gizlilik_icon"),
            ("Ayarlar", "ayarlar_icon")
        ]
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        let item = items[indexPath.section][indexPath.row]
        cell.iconBg.backgroundColor = item.color
        cell.titleLabel.text = item.title
        cell.iconImageView.image = UIImage(systemName: item.image)
        
      
        return cell
    }
  
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toTabBarVCs", sender: nil)
    }
    //GENEL UYARI MESAJLARI
    func makeAlert(titleInput: String, messageInput: String)
    {
        let alert = UIAlertController(title: title, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "YES", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}


