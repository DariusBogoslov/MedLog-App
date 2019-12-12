//
//  EntriesViewController.swift
//  MedLog
//
//  Created by Darius Bogoslov on 09/06/2018.
//  Copyright © 2018 Darius Bogoslov. All rights reserved.
//

import Foundation
import UIKit

class EntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var entriesTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        entriesTableView.dataSource = self
        entriesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate.orderByDate()
        entriesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = entriesTableView.dequeueReusableCell(withIdentifier: "entryCell") as! EntryCell
        
        cell.entryCellView.layer.cornerRadius = 15
        
        let cellData = userEntries[indexPath.row]
        cell.dateLabel.text = cellData[0]
        cell.bloodPressureLabel.text = cellData[1]
        cell.medicationLabel.text = cellData[2]
        
        return cell
    }
}
