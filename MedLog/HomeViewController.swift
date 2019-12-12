//
//  HomeViewController.swift
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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate.cleanUserData()
        delegate.retrieveFromFirestore()
        delegate.retrieveUserEntries()
        
        
        let db = Firestore.firestore()
        db.collection("users").whereField("account_id", isEqualTo: userID!).getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting document \(err)")
            } else {
                for each in snapshot!.documents {
                    if((each.data()["firstname"] != nil) && (each.data()["lastname"] != nil))
                    {
                        let firstname = each.data()["firstname"] as! String
                        let lastname = each.data()["lastname"] as! String
                        self.nameLabel.text = firstname + " " + lastname
                    }
                }
            }

        }
    }

    @IBAction func handleLogout (_ target: UIButton) {
        try! Auth.auth().signOut()
        
        self.dismiss(animated: false, completion: nil)
    }
}
