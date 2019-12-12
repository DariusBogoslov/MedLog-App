//
//  AddEntryViewController.swift
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

class AddEntryViewController: UIViewController {
    
    var scannedUserID: String = ""
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bloodPressureTextField: UITextField!
    @IBOutlet weak var medicationTextField: UITextField!
    @IBOutlet weak var addSuccessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        bloodPressureTextField.layer.cornerRadius = 5
        medicationTextField.layer.cornerRadius = 5
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: Date())
        dateLabel.text = date
    }
    
    @IBAction func addEntryToDB(_ sender: Any) {
        db.collection("users").document(scannedUserID).collection("entries").addDocument(data: [
            "date": self.dateLabel.text!,
            "blood_pressure": self.bloodPressureTextField.text!,
            "medication": self.medicationTextField.text!
        ]) { err in
            if let err = err {
                print("Error adding entry \(err)")
                self.addSuccessLabel.text = "Entry couldn't be added 😢"
            }
        }
        delegate.retrieveUserEntries()
        addSuccessLabel.text = "Entry was added 💉"
    }
    
    @IBAction func textField(_ sender: AnyObject) {
        self.view.endEditing(true);
    }
}
