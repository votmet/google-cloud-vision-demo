//
//  ProfileViewController+AdMob.swift
//  VisionDemo
//
//  Created by VMT on 2018/12/3.
//  Copyright © 2018 vmt. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension ProfileViewController: GADRewardBasedVideoAdDelegate {//GADInterstitialDelegate {
    func loadRewardBasedVideoAd() {
        secondProductCellData.isAdReady = false
        self.tableView.reloadData()
        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID];
        rewardBasedAd.load(request,
                           // production
                           // test
                           withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }
    func presentRewardBasedVideoAd() {
        print("to present video ad")
        if rewardBasedAd.isReady {
            print("presenting video ad")
            rewardBasedAd.present(fromRootViewController: self)
        }
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("receive video ad:", rewardBasedVideoAd)
        secondProductCellData.isAdReady = true
        self.tableView.reloadData()
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        self.loadRewardBasedVideoAd()
    }

    func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("video ad completes playing")
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        print("did receive reward \(reward.amount) \(reward.type)")
        IAPObserver.default.increaseBalance(Int(truncating: reward.amount))
    }
}
