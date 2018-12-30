//
//  RegisterViewController.swift
//  VisionDemo
//
//  Created by VMT on 2018/11/4.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

class RegisterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "profile_register".localized()
        
        self.view.backgroundColor = backgroundLightColor
        self.tableView.rowHeight = cellHeightDefault
    }

}

extension RegisterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        if indexPath.section == 3 {
            cell.textLabel?.textColor = primaryColor
            cell.textLabel?.text = "profile_register".localized()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "email".localized()
        case 1:
            return "password".localized()
        case 2:
            return "confirm_password".localized()
        default:
            return nil
        }
    }
}

