//
//  EditProfileViewController.swift
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


class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var dataUpdateLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var CNPTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressTextField.text = userData["address"]!
        cityTextField.text = userData["city"]!
        countyTextField.text = userData["county"]!
        emailTextField.text = userData["email"]!
        telephoneTextField.text = userData["telephone"]!
        IDTextField.text = userData["CI"]!
        CNPTextField.text = userData["CNP"]!
        statusTextField.text = userData["status"]!
    }
    
    @IBAction func textField(_ sender: AnyObject) {
        self.view.endEditing(true);
    }
    
    @IBAction func updateUserData(_ sender: Any) {
        
        db.collection("users").document(userData["document_id"]!).updateData([
            "address": addressTextField.text!,
            "City": cityTextField.text!,
            "County": countyTextField.text!,
            "email": emailTextField.text!,
            "telephone": telephoneTextField.text!,
            "CI": IDTextField.text!,
            "CNP": CNPTextField.text!,
            "Status": statusTextField.text!
            ])
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.retrieveFromFirestore()
        delegate.retrieveUserEntries()
        dataUpdateLabel.text = "Data was updated ✌🏻"
    }
}
