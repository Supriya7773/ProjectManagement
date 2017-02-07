//
//  DBHelper.swift
//  ProjectManagement
//
//  Created by Wohlig Technology on 07/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Foundation
import SQLite


class DBHelper: NSObject {
    
    var dB: Connection?;
    
    init(fromString string: NSString) {
        self.dB = nil;
        super.init();
        self.dB = createConnection();
        createDB()
    }
    
    func createConnection() -> (Connection){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print("DB is stores at :::  \(path)/db.sqlite3");
        dB = try! Connection("\(path)/db.sqlite3")
        
        return dB!;
    }
    
    
    func createDB() {
        
        if (dB != nil) {
            let users = Table("project")
            let projectId = Expression<Int64>("project_id")
            let projectTitle = Expression<String?>("project_title")
            let projectStartTime = Expression<String>("project_startTime")
            let projectEndTime = Expression<String>("project_endTime")
            let projectManager = Expression<String>("project_manager")
            let projectStatus = Expression<String>("project_status")
            
            try! dB?.run(users.create(ifNotExists: true) { t in
                t.column(projectId, primaryKey: true)
                t.column(projectTitle, unique: true)
                t.column(projectStartTime)
                t.column(projectEndTime)
                t.column(projectManager)
                t.column(projectStatus)
                
                print("\n PROJECT table created");
            })
        }
        
    }
    
    
}
