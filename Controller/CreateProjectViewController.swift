//
//  CreateProjectViewController.swift
//  ProjectManagement
//
//  Created by Wohlig Technology on 07/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class CreateProjectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var projectTitleTxtField: UITextField!
    
    @IBOutlet weak var projectManagerTxtField: UITextField!
    
    @IBOutlet weak var projectStartTimeField: UITextField!
    
    @IBOutlet weak var projectEndTimeField: UITextField!
    
    @IBOutlet weak var projectDatePicker: UIDatePicker!    
    
    @IBOutlet weak var projectStatusField: UITextField!
    
    var currentFocusedField: UITextField?
    var focusedColor: UIColor = UIColor.green
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("CreateProjectViewController called")
        // Do any additional setup after loading the view.
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
    
    //MARK: - Creating Project
    
    @IBAction func createProject(_ sender: UIButton) {
        
        var newProjectDict          = [String : String]();
        newProjectDict["pname"]     = projectTitleTxtField.text!;
        newProjectDict["pmanager"]  = projectManagerTxtField.text!;
        newProjectDict["pstart"]    = projectStartTimeField.text!;
        newProjectDict["pend"]      = projectEndTimeField.text!;
        newProjectDict["pstatus"]   = projectStatusField.text!;
        
        let helper:DBHelper = DBHelper.init(fromString: "w")
        let result = helper.addProject(aProject: newProjectDict)
        
        if result{
            print("Data saved SUCCESSFULLY")
            resetFields()
        }
        else{
            print("Project saving interrupted")
        }
    }
    
    
    //MARK: - DatePicker Delegate
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        if (currentFocusedField != nil) {
            let dateFormatter = DateFormatter()
            let dateObj = sender.date
            dateFormatter.dateFormat = "dd-MM-yyyy"
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
            print("Focused on start time")
            currentFocusedField = textField
            projectDatePicker.backgroundColor = focusedColor
            
        case 4:
            print("Focused on start time")
            currentFocusedField = textField
            projectDatePicker.backgroundColor = focusedColor
            
        default:
            print("Ignore case")
        }
        
               
        if currentFocusedField != nil {
            currentFocusedField?.backgroundColor = focusedColor
            textField.resignFirstResponder()
//            return false
        }
//        else{
            return true
//        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if !(currentFocusedField?.tag == 3 || currentFocusedField?.tag == 4) {
            projectDatePicker.backgroundColor = UIColor.clear
        }
        
        return true
    }

}
