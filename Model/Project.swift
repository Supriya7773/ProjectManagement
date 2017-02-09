//
//  Project.swift
//  ProjectManagement
//
//  Created by Wohlig Technology on 07/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class Project: NSObject {
    
    var pID     : String    = ""    
    var pName   : String    = ""
    var pManager: String    = ""
    var pStatus : String    = ""
    var pStart  : String    = ""
    var pEnd    : String    = ""
    
    override init() {
        super.init();
    }
    
    init(projectID: String,
         projectName: String,
         projectManager: String,
         projectStartDate: String,
         projectEndDate: String,
         projectStatus: String){
        
        pID         = projectID
        pName       = projectName
        pManager    = projectManager
        pStart      = projectStartDate
        pEnd        = projectEndDate
        pStatus     = projectStatus
    }
    
}
