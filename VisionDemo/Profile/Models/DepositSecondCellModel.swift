//
//  DepositSecondCellModel.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/17.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class DepositSecondCellModel: CellModel {
    var title: String {
        return isAdReady ? "profile_deposit_2".localized() : "profile_deposit_2_not_ready".localized()
    }
    
    var reusedIdentifier: String = "deposit_cell_2"
    
    
    var isAdReady = false
    
    func didSelect(from viewController: UIViewController) {
        if isAdReady, let viewController = viewController as? ProfileViewController {
            viewController.presentRewardBasedVideoAd()
        }
    }
}
