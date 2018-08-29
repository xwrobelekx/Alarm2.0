//
//  AlarmDetailTableViewController.swift
//  Alarm2.0
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titletextField: UITextField!
    @IBOutlet weak var eanbleButton: UIButton!
    
    //MARK: - Properties
    // this property will hold an alarm if were updatinf one, or will be nil if were creating one
    var alarmForUpdate : Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn : Bool = true // line 140 on README
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Methods
    private func updateViews() {
        if alarmForUpdate != nil {
        guard let alarm = alarmForUpdate else {return}
        alarmIsOn = alarm.enabled
        datePicker.date = alarm.fireDate
        titletextField.text = alarm.name
            
        if alarmIsOn {
        eanbleButton.setTitle("ON", for: .normal)
            eanbleButton.backgroundColor = .green
        } else {
            eanbleButton.setTitle("OFF", for: .normal)
            eanbleButton.backgroundColor = .gray
        }
        }
    }
    
    
    //MARK: - Actions
    
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        
    }
    
    

}
