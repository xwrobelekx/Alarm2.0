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
    
    
    //MARK: - CRUD Functions
    func createAlarm(fireDate: Date, name: String, enabled: Bool){
        let newAlarm = Alarm(name: name, fireDate: fireDate)
        newAlarm.enabled = enabled
        alarms.append(newAlarm)
        saveToPersistance()
        sheduleUserNotifications(for: newAlarm)
    }
    
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool){
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistance()
        sheduleUserNotifications(for: alarm)
    }
    
    func delete(alarm: Alarm){
        guard let index = alarms.index(of: alarm) else {return}
        alarms.remove(at: index)
        saveToPersistance()
        
    }
    
    
    //MARK: - Methods
    func toggleEnabled(for alarm: Alarm){
        // switches the switch from true to false and vice versa
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            //alarm enabled - schedule notifications
            sheduleUserNotifications(for: alarm)
        } else {
            // alarm not enabled - cancell notifications
            cancelUserNotifications(for: alarm)
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
        notificationContent.title = "\(alarm.name)"
        notificationContent.body = "Its \(alarm.fireTimeAsString), Wake UP!!"
        notificationContent.sound = UNNotificationSound.default()
        //get the date component using "current" on the "Calendar" - Date can be pulled from the fireDate from your alarm
        let dateComponents = Calendar.current.dateComponents([.minute, .second], from: alarm.fireDate)
        //next create Calendar Notification Trigger - date components needed - line202 from README
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let notificationRequest = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("There was an error while adding notification request: \(error) \(error.localizedDescription)")
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}





































