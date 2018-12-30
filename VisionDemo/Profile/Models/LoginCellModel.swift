//
//  LoginCellModel.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/17.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class LoginCellModel: CellModel {
    var title: String {
        guard UserDefaults.standard.string(forKey: UserDefaultsCKUserIDKey) != nil else {
            return "Tap to sync"
        }
        return "User ID".localized()
//        return UserDefaults.standard.string(forKey: UserDefaultsCKUserIDKey) ?? "profile_login".localized()
    }
    
    var detail: String? {
        return UserDefaults.standard.string(forKey: UserDefaultsCKUserIDKey)
    }
    
    func didSelect(from viewController: UIViewController) {
//        UserKit.default.sync()
//        viewController.navigationController?.pushViewController(LoginViewController(style: .grouped), animated: true)
    }
}
