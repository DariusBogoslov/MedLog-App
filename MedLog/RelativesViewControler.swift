//
//  RelativesViewControler.swift
//  MedLog
//
//  Created by Darius Bogoslov on 09/06/2018.
//  Copyright © 2018 Darius Bogoslov. All rights reserved.
//

import Foundation
import UIKit

class RelativesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var relativesEntriesTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        relativesEntriesTableView.dataSource = self
        relativesEntriesTableView.delegate = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor(red: 253/255, green: 233/255, blue: 70/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        relativesEntriesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "relativeDataSegue" ,
            let nextScene = segue.destination as? RelativesDataViewController ,
            let indexPath = self.relativesEntriesTableView.indexPathForSelectedRow {
            nextScene.cellIndex = indexPath.row           
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relativesGrantedAccess.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = relativesEntriesTableView.dequeueReusableCell(withIdentifier: "relativesEntry") as! RelativesEntryCell
        
        cell.relativesEntryView.layer.cornerRadius = 15
        
        let cellData = relativesGrantedAccess[indexPath.row]
        cell.emailLabel.text = cellData.email
        cell.nameLabel.text = cellData.name
        cell.relationshipLabel.text = cellData.relationship
        cell.statusLabel.text = cellData.status
        
        return cell
    }
    
}
