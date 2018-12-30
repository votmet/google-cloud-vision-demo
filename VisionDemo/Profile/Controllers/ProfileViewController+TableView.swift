//
//  ProfileViewController+TableView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/17.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit
import StoreKit

extension ProfileViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = cells[indexPath.section][indexPath.row]
        var dequeueReusableCell = tableView.dequeueReusableCell(withIdentifier: cellData.reusedIdentifier)
        if dequeueReusableCell == nil {
            dequeueReusableCell = UITableViewCell(style: .value1, reuseIdentifier: cellData.reusedIdentifier)
        }
        guard let cell = dequeueReusableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if let depositFirstProductCellData = cellData as? DepositFirstCellModel {
            self.firstProductCellData.cell = cell
            if cell.accessoryView == nil {
                let activityIndicatorView = UIActivityIndicatorView(style: .gray)
                activityIndicatorView.startAnimating()
                activityIndicatorView.hidesWhenStopped = true
                cell.accessoryView = activityIndicatorView
            }
            
            if let product = depositFirstProductCellData.product {
                cell.textLabel?.text = product.localizedTitle
                cell.detailTextLabel?.text = product.localizedDescription
                return cell
            } else {
                let activityIndicatorView = cell.accessoryView as! UIActivityIndicatorView
                activityIndicatorView.startAnimating()
            }
        }
        if cellData is DepositSecondCellModel {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        }
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0)
        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.detail
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cells[indexPath.section][indexPath.row].didSelect(from: self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "profile_section_title_settings".localized()
        }
//        if section == 2 {
//            return UserDefaults.standard.string(forKey: UserDefaultsCKUserIDKey)
//        }
        return nil
    }
    
}
