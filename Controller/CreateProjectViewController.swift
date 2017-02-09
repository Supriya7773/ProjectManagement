//
//  CreateProjectViewController.swift
//  ProjectManagement
//
//  Created by Wohlig Technology on 07/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import DropDown

enum dropDownListItems: String {
    case NEW = "NEW"
    case OPEN = "OPEN"
    case INTERNAL_TESTING = "INTERNAL_TESTING"
    case ALPHA_TESTING = "ALPHA_TESTING"
    case BETA_TESTING = "BETA_TESTING"
    case DEPLOYED = "DEPLOYED"
    case CLOSE = "CLOSE"
    case DONE = "DONE"
    case MAINTENANCE = "MAINTENANCE"
    
    static let allValues = [NEW, OPEN, INTERNAL_TESTING, ALPHA_TESTING, BETA_TESTING, DEPLOYED, CLOSE,  DONE, MAINTENANCE]
    
    init?(id : Int) {
        switch id {
        case 1:
            self = .NEW
        case 2:
            self = .OPEN
        case 3:
            self = .INTERNAL_TESTING
        case 4:
            self = .ALPHA_TESTING
        case 5:
            self = .BETA_TESTING
        case 6:
            self = .DEPLOYED
        case 7:
            self = .CLOSE
        case 8:
            self = .DONE
        case 9:
            self = .MAINTENANCE
            
        default:
            return nil
        }
    }
}

class CreateProjectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var projectTitleTxtField: UITextField!
    
    @IBOutlet weak var projectManagerTxtField: UITextField!
    
    @IBOutlet weak var projectStartTimeField: UITextField!
    
    @IBOutlet weak var projectEndTimeField: UITextField!
    
    @IBOutlet weak var projectDatePicker: UIDatePicker!    
    
    @IBOutlet weak var projectStatusField: UITextField!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var currentFocusedField: UITextField?
    var focusedColor: UIColor = UIColor.green
    var currentProject: Project? = nil
    var isInEditMode: Bool = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentProject != nil {
            isInEditMode = true
            reloadUIWithCurrentProject()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Helper Functions    
    
    func resetFields() {
        projectTitleTxtField.text       = "";
        projectManagerTxtField.text     = "";
        projectStartTimeField.text      = "";
        projectEndTimeField.text        = "";
        projectStatusField.text         = "";
        currentFocusedField             = nil;
    }
    
    func reloadUIWithCurrentProject() {
        projectTitleTxtField.text       = currentProject?.pName
        projectManagerTxtField.text     = currentProject?.pManager
        projectStartTimeField.text      = currentProject?.pStart
        projectEndTimeField.text        = currentProject?.pEnd
        projectStatusField.text         = currentProject?.pStatus
        finishButton.titleLabel?.text   = "Done"        
        currentFocusedField             = nil;
    }
    
    func showDropdownList(forView: UITextField!) {
        let fromView = forView
        let dropDown = DropDown()        
        dropDown.anchorView = fromView
        dropDown.dataSource = ["new","open","close","deployed","maintenance","testing"]
//        dropDown.show()
    }
    
    //MARK: - Creating/Editing Project
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        
        var projectDict          = [String : String]();
        projectDict["pname"]     = projectTitleTxtField.text!;
        projectDict["pmanager"]  = projectManagerTxtField.text!;
        projectDict["pstart"]    = projectStartTimeField.text!;
        projectDict["pend"]      = projectEndTimeField.text!;
        projectDict["pstatus"]   = projectStatusField.text!;
        
        if isInEditMode {
            projectDict["pid"]   = (currentProject?.pID)! as String
            updateProject(project: projectDict)
        }
        else{
            createProject(project: projectDict)
        }
    }
    
    func createProject(project: [String : String]) {
        
        let result = DBHelper.sharedInstance.addProject(aProject: project)
        
        if result{
            (UIApplication.shared.delegate as! AppDelegate).showToastMessage(message: "Project created successfully", forTime: nil)
            resetFields()
        }
        else{
            (UIApplication.shared.delegate as! AppDelegate).showToastMessage(message: "Project creation failed", forTime: nil)
        }
    }
    
    func updateProject(project: [String : String]) {
        
        let result = DBHelper.sharedInstance.updateProject(aProject: project, forProjectID: project["pid"]!)
        
        if result{
            (UIApplication.shared.delegate as! AppDelegate).showToastMessage(message: "Project updated successfully", forTime: nil)
            resetFields()
        }
        else{
            (UIApplication.shared.delegate as! AppDelegate).showToastMessage(message: "Project updation failed", forTime: nil)
        }
    }
    
    
    //MARK: - DatePicker Delegate
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        if (currentFocusedField != nil) {
            let dateFormatter = DateFormatter()
            let dateObj = sender.date
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            currentFocusedField?.text = dateFormatter.string(from: dateObj);
        }
    }
    
    
    // MARK: - Text field Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let textfieldTag = textField.tag;
        if (currentFocusedField != nil){
            currentFocusedField?.backgroundColor = UIColor.clear
            currentFocusedField = nil
        }
        
        switch textfieldTag {            
            case 3:            
                currentFocusedField = textField
                projectDatePicker.backgroundColor = focusedColor
                
            case 4:
                currentFocusedField = textField
                projectDatePicker.backgroundColor = focusedColor
            
            case 5:
                textField.resignFirstResponder()
                showDropdownList(forView: textField)                
                
            default:
                print("Ignore case")
        }
               
        if currentFocusedField != nil {
            currentFocusedField?.backgroundColor = focusedColor
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if !(currentFocusedField?.tag == 3 || currentFocusedField?.tag == 4) {
            projectDatePicker.backgroundColor = UIColor.clear
        }
        
        return true
    }

}
