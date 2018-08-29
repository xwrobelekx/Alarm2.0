//
//  AlarmController.swift
//  Alarm2.0
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation


class AlarmController {
    
    //MARK: - Source Of Truth
    var alarms : [Alarm] = []
    
    //MARK: - Singelton
    static let shared = AlarmController()
    
    //MARK: - Mockup data
    
    let mockupData : [Alarm] = {
    
      
        let fiveAmAlarm = Alarm(name: "5 Am Alarm", fireDate: Date(timeInterval: 1500, since: Date()))
        let sixAmAlarm = Alarm(name: "6 Am Alarm", fireDate: Date(timeInterval: 1000, since: Date()))
        let sevenAmAlarm = Alarm(name: "7 Am Alarm", fireDate: Date(timeInterval: 2000, since: Date()))

        return [fiveAmAlarm, sixAmAlarm, sevenAmAlarm]
    }()
    //asigned mockup data to alarms array
    init(){
    alarms = mockupData
    }
    
    
    
    //MARK: - CRUD Functions
    
    func createAlarm(fireDate: Date, name: String, enabled: Bool){
        let newAlarm = Alarm(name: name, fireDate: fireDate)
        newAlarm.enabled = enabled
        alarms.append(newAlarm)
    }
    
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        
    }
    
    func delete(alarm: Alarm){
        guard let index = alarms.index(of: alarm) else {return}
        alarms.remove(at: index)
    }
    
    
    
    //MARK: - Methods
    func toggleEnabled(for alarm: Alarm){
     // switches the switch from true to false and vice versa
     alarm.enabled = !alarm.enabled
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
