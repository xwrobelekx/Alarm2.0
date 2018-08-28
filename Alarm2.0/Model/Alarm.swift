//
//  Alarm.swift
//  Alarm2.0
//
//  Created by Kamil Wrobel on 8/28/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import Foundation


class Alarm: Equatable, Codable{
    
    //MARK: - Properties
    var name: String
    var enabled : Bool
    let uuid : String
    var fireDate: Date
    
    var fireTimeAsString: String {
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .none
        dateFormater.timeStyle = .short
        return dateFormater.string(from: fireDate)
    }
    
    //MARK: - Initializers
    init(name: String, enabled: Bool = true, uuid: String = UUID().uuidString, fireDate: Date){
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
        self.fireDate = fireDate
    }
    
    //MARK: - Equatable
    static func ==(lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
