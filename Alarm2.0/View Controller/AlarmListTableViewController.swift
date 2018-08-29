//
//  AlarmListTableViewController.swift
//  Alarm2.0
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit
// delegate pattern step 4 - adopt the protocol
class AlarmListTableViewController: UITableViewController, SwitchTableViewDelegate {
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.shared.alarms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "updateCell", for: indexPath) as? SwitchTableViewCell
        let alarmToDisplay = AlarmController.shared.alarms[indexPath.row]
        // delegate pattern step 6 - set the current cell as the delegate
        cell?.cellDelegate = self
        cell?.alarm = alarmToDisplay
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alarmToDelete = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: - Methods
    // delegate pattern step 5 - confrom to the protocol
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let alarmToggleToBeFlipped = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleEnabled(for: alarmToggleToBeFlipped)
        print("protocol conformance function fired up")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailTableViewSegue" {
            let destiantionVC = segue.destination as? AlarmDetailTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let tappedAlarm = AlarmController.shared.alarms[indexPath.row]
            destiantionVC?.alarmForUpdate = tappedAlarm
            print("segue activated, data sent over to detail view")
            
        }
    }
}

















