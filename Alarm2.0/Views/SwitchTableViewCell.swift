//
//  SwitchTableViewCell.swift
//  Alarm2.0
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

//delegate pattern step 1 - declare protocol
protocol SwitchTableViewDelegate: class{
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}


class SwitchTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    //MARK: - Properties
    var alarm: Alarm? {
        didSet{
            updateViews()
        }
    }
    
    //delegate pattern step 2 - set up delegate
    weak var cellDelegate: SwitchTableViewDelegate?
    
    //MARK: - Methods
    func updateViews(){
        guard let alarmPassedIn = alarm else {return}
        timeLabel.text = alarmPassedIn.fireTimeAsString
        nameLabel.text = alarmPassedIn.name
        alarmSwitch.isOn = alarmPassedIn.enabled
        print("updated all the views in cell")
    }
    
    
    //MARK: - Actions
    @IBAction func switchValueChanged(_ sender: Any) {
        // delegate pattern step 3 - call the delegate
        cellDelegate?.switchCellSwitchValueChanged(cell: self)
    }
}
