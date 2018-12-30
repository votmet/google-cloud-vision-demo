//
//  ProfileViewController.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/16.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit
import StoreKit
import GoogleMobileAds

class ProfileViewController: UITableViewController {

    let firstProductCellData = DepositFirstCellModel()
    let secondProductCellData = DepositSecondCellModel()
    var cells: [[CellModel]] = [
        [
            LanguageCellModel()
        ],
        [
            LoginCellModel(),
//            RegisterCellModel()
        ]
    ]
    
    var interstitial: GADInterstitial!
    var rewardBasedAd: GADRewardBasedVideoAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = backgroundLightColor
        self.tableView.rowHeight = cellHeightDefault
        cells.insert(
            [
                BalanceCellModel(),
                firstProductCellData,
                secondProductCellData
            ],
            at: 0
        )
        
        self.requestProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.reload), name: NSNotification.Name(rawValue: IAPPaymentNotificationDone), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.reload), name: Notification.Name(rawValue: CKNotificationUserUpdated), object: nil)

//        interstitial = self.createAndLoadInterstitial()
        rewardBasedAd = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedAd.delegate = self
        self.loadRewardBasedVideoAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
