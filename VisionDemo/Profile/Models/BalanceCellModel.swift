//
//  BalanceCellModel.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/17.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

let UserDefaultsBalanceKey = "VisionDemo_balance"

class BalanceCellModel: CellModel {
    var detail: String? {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: UserDefaultsBalanceKey) == nil {
            return "0"//restore".localized()
        }
        return String(UserDefaults.standard.integer(forKey: UserDefaultsBalanceKey))
    }
    var title: String {
        return "profile_balance".localized()
    }
    
    var style: UITableViewCell.CellStyle = .value1
    var reusedIdentifier: String = "balance"
    
    func didSelect(from viewController: UIViewController) {
        if let profileViewController = viewController as? ProfileViewController {
            profileViewController.restore()
        }
    }
}
