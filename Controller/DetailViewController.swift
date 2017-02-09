//
//  DetailViewController.swift
//  ProjectManagement
//
//  Created by Wohlig Technology on 07/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Foundation
import SideMenu
import Toaster

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var detailTableView: UITableView!
    
    var detailViewTableArray = [Project]();
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView?.dataSource = self;
        detailTableView?.delegate = self;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateDetailView()
    }
    
    // MARK: - Reload Detail View
    
    func updateDetailView() {
        detailViewTableArray = DBHelper.sharedInstance.getAllProjects()
        detailTableView?.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewTableArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return (UIView.init(frame: CGRect.zero))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath) as! detailViewTableViewCell
        
        let cellProjectData = detailViewTableArray[indexPath.row] as Project!
        
        
        cell.projectName.text = cellProjectData?.pName
        cell.projectManager.text = cellProjectData?.pManager
        cell.projectStatus.text = cellProjectData?.pStatus
        cell.projectDuration.text = (cellProjectData?.pStart)!+" to "+(cellProjectData?.pEnd)!
        
        return cell
    }
    
    
     // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { action, index in            
            self.deleteRowAtIndexPath(editActionsForRowAt: editActionsForRowAt)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.editRowAtIndexPath(editActionsForRowAt: editActionsForRowAt)
        }
        
        editAction.backgroundColor = .lightGray
        
        return [deleteAction, editAction]
    }
    
    
    //MARK: - Edit Project
    
    func editRowAtIndexPath(editActionsForRowAt: IndexPath) {
        let createProjectVC = self.storyboard?.instantiateViewController(withIdentifier: "createProjectView") as! CreateProjectViewController        
        createProjectVC.currentProject = detailViewTableArray[editActionsForRowAt.row] as Project!
        self.navigationController?.present(createProjectVC, animated: true, completion: nil)
    }
    
    func deleteRowAtIndexPath(editActionsForRowAt: IndexPath) {
        
        let alertViewController = UIAlertController(title: "", message: "Are you sure want to delete \((detailViewTableArray[editActionsForRowAt.row] as Project!).pName)", preferredStyle: .alert)
        
        //Cancel Action
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        //Delete Action
        alertViewController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (alertAction) in            
            let result = DBHelper.sharedInstance.deleteProject(forProjectID: (self.detailViewTableArray[editActionsForRowAt.row] as Project!).pID)
            if result{
                (UIApplication.shared.delegate as! AppDelegate).showToastMessage(message: "Project deleted successfully", forTime: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.updateDetailView()                    
                })
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    // your code here
//                }
                
            }
            else{
                (UIApplication.shared.delegate as! AppDelegate).showToastMessage(message: "Project deletion failed", forTime: nil)
            }
            
        }))
        
        
        present(alertViewController, animated: true, completion: nil)
    }
    
}
