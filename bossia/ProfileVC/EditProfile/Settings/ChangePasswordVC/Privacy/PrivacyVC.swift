//
//  PrivacyVC.swift
//  bossia
//
//  Created by ONUR BOSTAN on 15.08.2023.
//

import UIKit

class PrivacyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let privacyPolicyText = """
    We, the Company Name, as the data controller, with this privacy and personal data protection policy, which personal data will be processed for what purpose, with whom and why the processed data can be shared, our data processing method and our legal reasons; We aim to enlighten you about your rights regarding your processed data.
    """
    
    let privacyPolicyText2 = """
    Your personal data that you share with us only by analyzing; to fulfill the requirements of the services we offer in the best way, to ensure that these services can be accessed and utilized by you at the maximum level, to develop our services in line with your needs and to bring you together with broader service providers within legal frameworks, It will be processed and updated in accordance with its purpose and proportionately during the contract and service period, in order to fulfill the

    """
    let privacyPolicyText3 = """
    Anyone who initiates article 11 of the KVKK applies to the data controller and uses the following way:

    Learning whether personal data is processed or not,
    Requesting information processed on personal data accordingly,
    Learning the purpose of processing personal data and whether they are used in accordance with its purpose,
    Knowing the third parties to whom personal data is transferred at home or abroad,
    Requesting the characteristics of personal data in case of incomplete or incorrect processing,
    To request the deletion or storage of personal data,
    To be protected without structuring clauses (e) and (f), to request notification of third parties to whom personal data is transferred,
    To have the processed histories analyzed exclusively the drawings of automatic structures, to object to the emergence of a result against one's own detriment,
    It has the right to demand the protection of the damage in the event that personal data is unlawfully restricted and damaged.
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyCell", for: indexPath) as! PrivacyCell
        cell.privacyLabel.text = privacyPolicyText
        cell.privacyLabel2.text = privacyPolicyText2
        cell.privacyLabel3.text = privacyPolicyText3
        return cell
    }
}
