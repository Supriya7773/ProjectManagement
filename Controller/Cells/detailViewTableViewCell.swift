//
//  detailViewTableViewCell.swift
//  ProjectManagement
//
//  Created by Wohlig Technology on 09/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class detailViewTableViewCell: UITableViewCell {

   
    @IBOutlet weak var projectName: UILabel!

    @IBOutlet weak var projectManager: UILabel!
    
    @IBOutlet weak var projectStatus: UILabel!
    
    @IBOutlet weak var projectDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
