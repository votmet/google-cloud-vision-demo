//
//  LanguageCellModel.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/17.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class LanguageCellModel: CellModel {
    var title: String {
        return "profile_language".localized()
    }
    
    func didSelect(from viewController: UIViewController) {
        viewController.navigationController?.pushViewController(LanguagesViewController(), animated: true)
    }
}
