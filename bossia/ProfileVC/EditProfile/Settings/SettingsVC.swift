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
    
    //ITEMS DİZİSİ OLUŞTURULUR (TABLEVIEW'DE GÖSTEREBİLMEK İÇİN)
    
    let items: [[(title: String, image: String, color: UIColor?)]] = [
        [(title: "Edit Profile", image: "person.fill", color: UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0)),
        (title: "Change Password", image: "lock.fill", color: UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)),
        ],
        [(title: "Favorite Posts", image: "star.fill", color: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)),
        ],
        [(title: "Logout", image: "rectangle.portrait.and.arrow.right", color: .red)]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
    }
    
    //TABLEVIEW'DE ITEMS DİZİSİNİN GÖSTERİLMESİ İÇİN;
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.row].title
        
        switch item {
        case "Edit Profile":
            self.performSegue(withIdentifier: "goProfileEdit", sender: nil)
            break
        case "Change Password":
            self.performSegue(withIdentifier: "changePasswordGo", sender: nil)
            break
        case "Favorite Posts":
            print("Success")
            break
        case "Logout":
            do
            {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "toOutVC", sender: nil)
            } catch
                {
                print("error")
            }
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
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


