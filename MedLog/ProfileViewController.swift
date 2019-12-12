//
//  ProfileViewController.swift
//  MedLog
//
//  Created by Darius Bogoslov on 09/06/2018.
//  Copyright © 2018 Darius Bogoslov. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileAvatar: UIImageView!
    
    override func viewDidLoad() {
        self.profileAvatar.layer.cornerRadius = self.profileAvatar.frame.size.width / 2
        self.profileAvatar.clipsToBounds = true
        self.profileAvatar.layer.borderWidth = 3.0
        self.profileAvatar.layer.borderColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor(red: 253/255, green: 233/255, blue: 70/255, alpha: 1.0)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var IDLabel: UILabel!
    @IBOutlet weak var CNPLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileData()
    }
    
    func setProfileData() {
        nameLabel.text = userData["firstname"]! + " " + userData["lastname"]!
        addressLabel.text = userData["address"]!
        cityLabel.text = userData["city"]!
        countyLabel.text = userData["county"]!
        emailLabel.text = userData["email"]!
        telephoneLabel.text = userData["telephone"]!
        IDLabel.text = userData["CI"]!
        CNPLabel.text = userData["CNP"]!
        statusLabel.text = userData["status"]!
    }
}
