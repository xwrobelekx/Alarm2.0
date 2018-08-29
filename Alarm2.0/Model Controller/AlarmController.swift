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
        saveToPersistance()
        print("created new alarm from alarm controller")
    }
    
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistance()
        print("update function called from Alarm controller")
        
        
    }
    
    func delete(alarm: Alarm){
        guard let index = alarms.index(of: alarm) else {return}
        alarms.remove(at: index)
        saveToPersistance()
        print("delete function called from Alarm controller")
    }
    
    
    
    //MARK: - Methods
    func toggleEnabled(for alarm: Alarm){
     // switches the switch from true to false and vice versa
     alarm.enabled = !alarm.enabled
        print("toggle switch flipped")
        
        
    }
    
    
    
    //MARK: - Persistance
    
    //Get URL From FileMAnager
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "Alarm.json"
        let documentDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentDirectoryURL
        
    }
    
    // Save to persistance

    private func saveToPersistance(){
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(alarms)
            try data.write(to: fileURL())
        }catch {
            print("Failed saving to persistance store: \(error) \(error.localizedDescription)")
        }
        print("saved to persistance called")
    }
    
    
    
    
    
    //Load from Persistance
    func loadFromPersistance() -> [Alarm]{
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let alarmArray = try decoder.decode([Alarm].self, from: data)
            return alarmArray
            print("loaded from persistance")
        } catch {
             print("Failed loading from persistance store: \(error) \(error.localizedDescription)")
        }
        return []
        print("loaded from persistance called but were unable to load data")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
