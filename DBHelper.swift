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
    
    static let sharedInstance = DBHelper(fromString: "path")
    
    let users = Table("project")
    let projectId = Expression<Int64>("project_id")
    let projectTitle = Expression<String?>("project_title")
    let projectStartTime = Expression<String>("project_startTime")
    let projectEndTime = Expression<String>("project_endTime")
    let projectManager = Expression<String>("project_manager")
    let projectStatus = Expression<String>("project_status")
    
    
    init(fromString string: NSString) {
        
        print("\n In DBHelper's INIT\n")
        
        self.dB = try! Connection();
        super.init();
        self.dB = createConnection();
        createDB()
    }
    
    func createConnection() -> (Connection){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print("\n DB is stores at :::\n  \(path)/db.sqlite3 \n\n");
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
            
            print("\n PROJECT table created \n");
        })
       
        
    }
    
    //MARK: - INSERT
    
    func addProject(aProject: [String:String]) -> (Bool){
        let users = Table("project")
        try! dB.run(users.insert(projectManager <- aProject["pmanager"]!,
                                  projectTitle <- aProject["pname"]!,
                                  projectStartTime <- aProject["pstart"]!,
                                  projectEndTime <- aProject["pend"]!,
                                  projectStatus <- aProject["pstatus"]!))
        return true
    }
    
    
    //MARK: - UPDATE
    
    func updateProject(aProject: [String:String], forProjectID: String) -> (Bool) {
        do {
            let alice = users.filter(projectId == Int64(forProjectID)!)
            if try dB.run(alice.update(projectTitle <- aProject["pname"]!,
                                       projectManager <- aProject["pmanager"]!,
                                       projectStartTime <- aProject["pstart"]!,
                                       projectEndTime <- aProject["pend"]!,
                                       projectStatus <- aProject["pstatus"]!)) > 0 {
            } else {
                return false
            }
        } catch {
            print("update failed: \(error)")
            return false
        }
        return true
    }
    
    
    //MARK: - DELETE
    
    func deleteProject(forProjectID: String) -> (Bool) {
        let alice = users.filter(projectId == Int64(forProjectID)!)
        do {
            if try dB.run(alice.delete()) > 0 {                
            } else {
                return false
            }
        } catch {
            print("delete failed: \(error)")
            return false
        }
        
        return true
    }
    
    //MARK: - SELECT ALL
    
    func getAllProjects() -> (Array<Project>) {
        
        var allProject = [Project]()
        
        for user in try! dB.prepare(users) {
            let newProject:Project = Project(projectID: String(user[projectId]),
                                             projectName: user[projectTitle]!, 
                                             projectManager: user[projectManager], 
                                             projectStartDate: user[projectStartTime], 
                                             projectEndDate: user[projectEndTime], 
                                             projectStatus: user[projectStatus])
            allProject.append(newProject)
        }
        
        return allProject
    }
    
}
