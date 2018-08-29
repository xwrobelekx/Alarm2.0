//
//  AlarmController.swift
//  Alarm2.0
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation
import UserNotifications


class AlarmController: AlarmScheduler {
    
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
    
    //MARK: - User Notification Delegate
    weak var userNotificationDelegate : AlarmScheduler?
    
    
    
    //MARK: - CRUD Functions
    
    func createAlarm(fireDate: Date, name: String, enabled: Bool){
        let newAlarm = Alarm(name: name, fireDate: fireDate)
        newAlarm.enabled = enabled
        alarms.append(newAlarm)
        saveToPersistance()
        userNotificationDelegate?.sheduleUserNotifications(for: newAlarm)
        print("created new alarm from alarm controller")
        
    }
    
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistance()
        userNotificationDelegate?.sheduleUserNotifications(for: alarm)
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
        if alarm.enabled {
           //alarm enabled - schedule notifications
            userNotificationDelegate?.sheduleUserNotifications(for: alarm)
        } else {
            // alarm not enabled - cancell notifications
            userNotificationDelegate?.cancelUserNotifications(for: alarm)
        }
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
            print("loaded from persistance")
            return alarmArray
            
        } catch {
             print("Failed loading from persistance store: \(error) \(error.localizedDescription)")
        }
        print("loaded from persistance called but were unable to load data")
        return []
        
    }

    
}


//MARK: - User Notifications

//#1 declare the protocol for notifications
protocol AlarmScheduler :class{
    func sheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

//#2 extend the protocol to do some default implementations
extension AlarmScheduler {
    
    func sheduleUserNotifications(for alarm: Alarm){
        //create an instance of the Notification content, and set the properties.
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(alarm.name) - working?"
        notificationContent.body = "Its \(alarm.fireTimeAsString), Wake UP!!"
        notificationContent.sound = UNNotificationSound.default()
        
        
        
        //get the date component using "current" on the "Calendar" - Date can be pulled from the fireDate from your alarm
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: alarm.fireDate)
        
        //next create Calendar Notification Trigger - date components needed - line202 from README
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        
        let notificationRequest = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: notificationTrigger)
        
        
        
    }
    
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    
}





































