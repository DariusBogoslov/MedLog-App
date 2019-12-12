//
//  RelativesDataViewController.swift
//  MedLog
//
//  Created by Darius Bogoslov on 09/06/2018.
//  Copyright © 2018 Darius Bogoslov. All rights reserved.
//

import Foundation
import UIKit

class RelativesDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var relativesDataEntriesTableView: UITableView!
    var entriesCount = relativesGrantedAccess
    var cellIndex: Int = -1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        relativesDataEntriesTableView.dataSource = self
        relativesDataEntriesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relativesGrantedAccess[cellIndex].relativeEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = relativesDataEntriesTableView.dequeueReusableCell(withIdentifier: "relativeDataEntryCell") as! RelativeDataEntryCell
        
        cell.relativeDataView.layer.cornerRadius = 15
        
        let cellData = relativesGrantedAccess[cellIndex]
        let relativeCellData = cellData.relativeEntries[indexPath.row]
        cell.dateLabel.text = relativeCellData[0]
        cell.bloodPressureLabel.text = relativeCellData[1]
        cell.medicationLabel.text = relativeCellData[2]
        
        return cell
    }
}
