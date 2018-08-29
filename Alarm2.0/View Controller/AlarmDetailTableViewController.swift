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
            print("loaded the views on the did set property in details view")
        }
    }
    
    var alarmIsOn : Bool = true // line 140 on README
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Methods
    private func updateViews() {
       
        guard let alarm = alarmForUpdate else {return}
        alarmIsOn = alarm.enabled
        datePicker.date = alarm.fireDate
        titletextField.text = alarm.name
            
        updateButtonApperiance()
        
    }
    
    func updateButtonApperiance(){
        if alarmIsOn {
            eanbleButton.setTitle("ON", for: .normal)
            eanbleButton.backgroundColor = .green
        } else {
            eanbleButton.setTitle("OFF", for: .normal)
            eanbleButton.backgroundColor = .gray
        }
    }
    
    
    //MARK: - Actions
    
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        //make sure were alarm to switch the value on
        guard let alarm = alarmForUpdate else {return}
        //flip the switch
        AlarmController.shared.toggleEnabled(for: alarm)
        //assign that value to our bool value so we can change the apperance of the button
        alarmIsOn = alarm.enabled
        // call the update on the button
        updateButtonApperiance()
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = titletextField.text else {return}
        guard name != "" else {return}
        
        
        if let alarmUnwrapped = alarmForUpdate {
            // update existing alarm
            AlarmController.shared.update(alarm: alarmUnwrapped, fireDate: datePicker.date, name: name, enabled: alarmIsOn)
            print("updated alarm")
        } else {
            //create new alarm
            AlarmController.shared.createAlarm(fireDate: datePicker.date, name: name, enabled: alarmIsOn)
            print("created new alarm")
           
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    

}
