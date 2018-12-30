//
//  DepositFirstCellModel.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/17.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit
import StoreKit

let DepositFirstProductValue = 6

class DepositFirstCellModel: CellModel {
    
    enum CellProductStatus {
        case idle, featching, success, failed
    }
    
    static let productIdentifier = "vmt.M.Coin"
    var title: String {
        switch productStatus {
        case .idle:
            return "profile_deposit_1".localized()
        case .featching:
            return "profile_deposit_1".localized()
        case .success:
            return self.product!.localizedTitle
        case .failed:
            return "product_request_failed".localized()
        }
    }
    
    var productStatus: CellProductStatus = .idle
    
    var product: SKProduct?
    weak var cell: UITableViewCell?
    
    func didSelect(from viewController: UIViewController) {
        if let profileViewController = viewController as? ProfileViewController {
            profileViewController.buyFirstProduct()
        }
    }
}
