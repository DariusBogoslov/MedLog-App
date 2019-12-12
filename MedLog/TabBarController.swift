//
//  TabBarController.swift
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

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var userRole: String? = nil
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        db.collection("users").whereField("account_id", isEqualTo: userID!).getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting document \(err)")
            } else {
                for each in snapshot!.documents {
                    userRole = each.data()["user_class"] as? String
                }
            }
            
            if((userRole != "Administrator") && (userRole != "Doctor"))
            {
                self.viewControllers?.remove(at: 4)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 0  {
            viewController.viewDidLoad()
        }
    }    
}
