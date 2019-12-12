//
//  AppDelegate.swift
//  MedLog
//
//  Created by Darius Bogoslov on 09/06/2018.
//  Copyright © 2018 Darius Bogoslov. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

let primaryColor = UIColor(red: 76/255, green: 76/255, blue: 66/255, alpha: 1)
let secondaryColor = UIColor(red: 248/255, green: 225/255, blue: 68/255, alpha: 1)
var userData: [String: String] = ["firstname": "", "lastname": "", "email": "", "telephone": "", "user_class": "", "document_id": "", "user_id": "", "address": "", "account_id": "", "status": "", "county": "", "city": "", "CNP": "", "CI": "", "user_entries": "", "relatives": ""]
var userEntries = [[String]]()

struct relativeGrantedAccess {
    var relationship = ""
    var email = ""
    var status = ""
    var name = ""
    var relativeEntries = [[String]]()
    
    init(relationship: String) {
        self.relationship = relationship
    }
}

var relativesUserID: [String] = []

var relativesGrantedAccess: [relativeGrantedAccess] = []

let db = Firestore.firestore()
let userID = Auth.auth().currentUser?.uid

let delegate = UIApplication.shared.delegate as! AppDelegate

var userCount: Int = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor(red: 253/255, green: 233/255, blue: 70/255, alpha: 1.0)
        
        FirebaseApp.configure()
        getUserCount()
        return true
    }
    
    func cleanUserData() {
        userData = ["firstname": "", "lastname": "", "email": "", "telephone": "", "user_class": "", "document_id": "", "user_id": "", "address": "", "account_id": "", "status": "", "county": "", "city": "", "CNP": "", "CI": "", "user_entries": "", "relatives": ""]
        userEntries.removeAll()
        relativesGrantedAccess.removeAll()
    }
    
    func retrieveFromFirestore() {
        cleanUserData()
        db.collection("users").whereField("account_id", isEqualTo: userID!).getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents \(err)")
            } else {
                for each in snapshot!.documents {
                        userData["document_id"]?.append(each.documentID)
                        self.retrieveRelativesIDs()
                        userData["firstname"]?.append(each.data()["firstname"] as! String)
                        userData["lastname"]?.append(each.data()["lastname"] as! String)
                        userData["email"]?.append(each.data()["email"] as! String)
                        userData["user_class"]?.append(each.data()["user_class"] as! String)
                        let user_id = each.data()["user_id"]
                        userData["user_id"]?.append("\(String(describing: user_id))")
                        userData["account_id"]?.append(each.data()["account_id"] as! String)
                    
                        if (each.data()["telephone"] != nil) {
                            userData["telephone"]?.append(each.data()["telephone"] as! String)
                            userData["address"]?.append(each.data()["address"] as! String)
                            userData["status"]?.append(each.data()["Status"] as! String)
                            userData["county"]?.append(each.data()["County"] as! String)
                            userData["city"]?.append(each.data()["City"] as! String)
                            userData["CNP"]?.append(each.data()["CNP"] as! String)
                            userData["CI"]?.append(each.data()["CI"] as! String)
                        }
                }
            }
        }
    }
    
    func retrieveUserEntries() {
        userEntries.removeAll()
        db.collection("users").whereField("account_id", isEqualTo: userID!).getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting document \(err)")
            } else {
                db.collection("users").document((snapshot?.documents[0].documentID)!).collection("entries").getDocuments() { (snapshot, err) in
                    if let err = err {
                        print("Error getting document \(err)")
                    } else {
                            for each in snapshot!.documents {
                                var group = [String]()
                                group.append(each.data()["date"] as! String)
                                group.append(each.data()["blood_pressure"] as! String)
                                group.append(each.data()["medication"] as! String)
                                userEntries.append(group)
                            }
                        }
                    }
                }
            }
    }
    
    func retrieveRelativesIDs() {
        db.collection("users").document(userData["document_id"]!).collection("grantedAccess").getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents \(err)")
            } else {
                for each in snapshot!.documents {
                    let relationship = each.data()["relationship"]
                    var currentRelative = relativeGrantedAccess(relationship: relationship as! String)
                    print(each.data())
                    let relativeID = each.data()["user_doc_id"]
                    if(relativeID != nil) {
                    db.collection("users").document(relativeID! as! String).getDocument() { (document, err) in
                            if let err = err {
                                print("Error getting document \(err)")
                            } else {
                                currentRelative.email = document?.data()!["email"] as! String
                                let firstname = document?.data()!["firstname"] as! String
                                let lastname = document?.data()!["lastname"] as! String
                                currentRelative.name = firstname + " " + lastname
                                currentRelative.status = document?.data()!["Status"] as! String
                                db.collection("users").document(relativeID! as! String).collection("entries").getDocuments() {
                                    (snapshot, err) in
                                    if let err = err {
                                        print("Error getting document \(err)")
                                    } else {
                                        for each in snapshot!.documents {
                                            var group = [String]()
                                            group.append(each.data()["date"] as! String)
                                            group.append(each.data()["blood_pressure"] as! String)
                                            group.append(each.data()["medication"] as! String)
                                            currentRelative.relativeEntries.append(group)
                                        }
                                        relativesGrantedAccess.append(currentRelative)
                                    }
                                }
                        }
                    }
                    }
                }
            }
        }
    }
    
    func getUserCount() {
        db.collection("users").getDocuments() { (snapshot, err) in
            userCount = snapshot!.count
        }
    }
    
    func orderByDate() {
        userEntries.sort(by: {$0[0].compare($1[0]) == .orderedAscending})
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

