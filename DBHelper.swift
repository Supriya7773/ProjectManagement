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
    
    var dB: Connection;
    
    let users = Table("project")
    let projectId = Expression<Int64>("project_id")
    let projectTitle = Expression<String?>("project_title")
    let projectStartTime = Expression<String>("project_startTime")
    let projectEndTime = Expression<String>("project_endTime")
    let projectManager = Expression<String>("project_manager")
    let projectStatus = Expression<String>("project_status")
    
    
    init(fromString string: NSString) {
        self.dB = try! Connection();
        super.init();
        self.dB = createConnection();
        createDB()
        
        let allProjectsInDB = getAllProjects()
        for aProject:Project in allProjectsInDB {
            print("\n\n Name: \(aProject.pName) \n Manager: \(aProject.pManager)");
        }
    }
    
    func createConnection() -> (Connection){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print("DB is stores at :::  \(path)/db.sqlite3");
        dB = try! Connection("\(path)/db.sqlite3")
        
        return dB;
    }
    
    
    func createDB() {
            
        try! dB.run(users.create(ifNotExists: true) { t in
            t.column(projectId, primaryKey: .autoincrement)
            t.column(projectTitle, unique: true)
            t.column(projectStartTime)
            t.column(projectEndTime)
            t.column(projectManager)
            t.column(projectStatus)
            
            print("\n PROJECT table created");
        })
       
        
    }
    
    func addProject(aProject: [String:String]) -> (Bool){
        let users = Table("project")
        try! dB.run(users.insert(projectManager <- aProject["pmanager"]!,
                                  projectTitle <- aProject["pname"]!,
                                  projectStartTime <- aProject["pstart"]!,
                                  projectEndTime <- aProject["pend"]!,
                                  projectStatus <- aProject["pstatus"]!))

        
        for user in try! dB.prepare(users) {
            print("projectTitle: \(user[projectTitle]), projectManager: \(user[projectManager])")
        }
        
        return true
    }
    
    func getAllProjects() -> (Array<Project>) {
        
        var allProject = [Project]()
        
        for user in try! dB.prepare(users) {
            print("\n\n ProjectID: \(user[projectId])    projectTitle: \(user[projectTitle]))")
            let newProject:Project = Project(projectName: user[projectTitle]!, 
                                             projectManager: user[projectManager], 
                                             projectStartDate: user[projectStartTime], 
                                             projectEndDate: user[projectEndTime], 
                                             projectStatus: user[projectStatus])
            allProject.append(newProject)
        }
        
        return allProject
    }
    
}
