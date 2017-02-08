//
//  DetailViewController.swift
//  ProjectManagement
//
//  Created by Wohlig Technology on 07/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var detailTableView: UITableView!
    
    var detailViewTableArray = [String]();
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView?.dataSource = self;
        detailTableView?.delegate = self;
        detailTableView?.reloadData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateDetailView()
    }
    
    
    //MARK: - UI Helpers
    
    func setNavigationBarItems(){
        let btn1 = UIButton(type: .contactAdd)
//        btn1.setImage(UIImage(named: "imagename"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(createProject), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }
    
    // MARK: - Reload Detail View
    
    func updateDetailView() {
        print(detailViewTableArray)
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "masterViewCell", for: indexPath)
        
        cell.textLabel?.text = detailViewTableArray[indexPath.row];
        return cell
    }
    
    
     // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n Item selected: \(detailViewTableArray[indexPath.row])");
    }
    
    
    
    
    // MARK: - Add Project
    
    func createProject(){
        print("\n\n Create project called")
        let creteProjVC:CreateProjectViewController = CreateProjectViewController();
        print("\n\n navigation object: \(self.navigationController)")
        self.navigationController?.pushViewController(creteProjVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
