//
//  RegisterCellModel.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/17.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class RegisterCellModel: CellModel {
    var title: String {
        return userName ?? UserDefaults.standard.string(forKey: UserDefaultsCKUserNameKey) ?? "profile_register".localized()
    }
    var userName: String? {
        didSet {
            if let name = userName {
                UserDefaults.standard.set(name, forKey: UserDefaultsCKUserNameKey)
//                UserKit.default.update(name: name)
            }
        }
    }
    
    func didSelect(from viewController: UIViewController) {
//        viewController.navigationController?.pushViewController(RegisterViewController(style: .grouped), animated: true)
        let settingsController = UIAlertController(title: "Name".localized(), message: nil, preferredStyle: .alert)
        settingsController.addTextField { (textField) in
            textField.text = UserDefaults.standard.string(forKey: UserDefaultsCKUserNameKey)
        }
        settingsController.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        settingsController.addAction(UIAlertAction(title: "Update".localized(), style: .default, handler: { [weak settingsController] (_) in
            guard let textField = settingsController?.textFields?.first, let name = textField.text else {
                return
            }
            self.userName = name
        }))
        viewController.present(settingsController, animated: true, completion: nil)
    }
}
