//
//  IAPObserver.swift
//  VisionDemo
//
//  Created by VMT on 2018/11/28.
//  Copyright © 2018 vmt. All rights reserved.
//
import Foundation
import CloudKit
import StoreKit

let IAPPaymentNotificationDone = "VisionDemo_payment_done"
let CKNotificationUserUpdated = "VisionDemo_user_updated"
let UserDefaultsCKUserIDKey = "VisionDemo_ck_user_id"
let UserDefaultsCKUserNameKey = "VisionDemo_ck_user_name"

class IAPObserver: NSObject, SKPaymentTransactionObserver {
    static let `default` = IAPObserver()
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("puchasing")
            case .purchased:
                print("purchased")
                self.purchased(transaction: transaction)
            case .failed:
                print("failed")
                self.failed(transaction: transaction)
            case .restored:
                print("restored")
                self.restored(transaction: transaction)
            case .deferred:
                print("deferred")
            }
        }
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        self.finishPaymentTransaction(transaction)
    }
    
    private func purchased(transaction: SKPaymentTransaction) {
        self.finishPaymentTransaction(transaction)
        // TODO: detect the product
        print("purchased:", transaction.payment.productIdentifier)
        
        self.increaseBalance(10)
    }
    
    private func restored(transaction: SKPaymentTransaction) {
        self.finishPaymentTransaction(transaction)
        print("restored:", transaction.payment)
    }
    
    private func finishPaymentTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPPaymentNotificationDone), object: nil, userInfo: nil)
//        if let cell = self.firstProductCellData.cell, let activityIndicator = cell.accessoryView as? UIActivityIndicatorView {
//            activityIndicator.stopAnimating()
//        }
    }
    
    func increaseBalance(_ balance: Int) {
        let currentBalance = UserDefaults.standard.integer(forKey: UserDefaultsBalanceKey)
        let totalBalance = currentBalance + balance
        UserDefaults.standard.set(totalBalance, forKey: UserDefaultsBalanceKey)
//        UserKit.default.update(balance: totalBalance)
//        self.tableView.reloadData()
    }
    
}

class UserKit: NSObject {
    static let `default` = UserKit()
    
    let container = CKContainer.default()
    var userPoints: Int?
    var userName: String?
    var userRecord: CKRecord? {
        didSet {
            if userRecord != nil {
                if let points = userPoints {
                    self.update(balance: points)
                }
                if let name = userName {
                    self.update(name: name)
                }
            }
        }
    }
    
    func sync(from viewController: UIViewController? = nil) {
        container.accountStatus { (status, error) in
            if status == .noAccount {
                if let controller = viewController {
                    let alertController = UIAlertController(title: "Sign in to iCloud", message: "The iCloud account is required to sync you personal settings", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    controller.present(alertController, animated: true, completion: nil)
                }
            } else {
                self.container.fetchUserRecordID { (userRecordID, error) in
                    guard let userRecordID = userRecordID, error == nil else {
                        print("fetch user id error:".uppercased(), error?.localizedDescription ?? "")
                        return
                    }
                    UserDefaults.standard.setValue(userRecordID.recordName, forKey: UserDefaultsCKUserIDKey)
                    self.syncUser(recordID:userRecordID)
                }
            }
        }
    }
    
    private func syncUser(recordID: CKRecord.ID) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CKNotificationUserUpdated), object: nil, userInfo: nil)
        print("fetching points of user:".uppercased(), recordID)
        container.publicCloudDatabase.fetch(withRecordID: recordID) { (record, error) in
            guard let record = record, error == nil else {
                print("fetch user record error:".uppercased(), error?.localizedDescription ?? "")
                return
            }
            
            self.userRecord = record
            print("user record".uppercased(), record, record.recordChangeTag ?? "")
            
            if let name = record["name"] as? String {
                UserDefaults.standard.set(name, forKey: UserDefaultsCKUserNameKey)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CKNotificationUserUpdated), object: nil, userInfo: nil)
            }
            
            guard let points = record["points"] as? Int else {
                self.update()
                return
            }
            
            print("fetched user points:".uppercased(), points)
            UserDefaults.standard.set(points, forKey: UserDefaultsBalanceKey)
        }
    }
    
    func update(balance: Int? = nil) {
        print("to update user record with points:".uppercased(), balance ?? 0)
        var points = balance
        if points == nil {
            points = UserDefaults.standard.integer(forKey: UserDefaultsBalanceKey)
        }
        self.userPoints = points
        if let record = self.userRecord, let points = points {
            record["points"] = points
            container.publicCloudDatabase.save(record) { (record, error) in
                guard let userRecord = record, error == nil else {
                    print("update user record error:".uppercased(), error?.localizedDescription ?? "ERROR")
                    return
                }
                print("updated user record with points:".uppercased(), points)
                self.userPoints = nil
                self.userRecord = userRecord
            }
        } else {
            print("no user record".uppercased())
            self.sync()
        }
    }
    
    func update(name: String) {
        print("to update user name:".uppercased(), name)
        self.userName = name
        if let record = self.userRecord {
            record["name"] = name
            container.publicCloudDatabase.save(record) { (record, error) in
                guard let userRecord = record, error == nil else {
                    print("update user record error:".uppercased(), error?.localizedDescription ?? "ERROR")
                    return
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CKNotificationUserUpdated), object: nil, userInfo: nil)
                print("updated user name:".uppercased(), name)
                self.userName = nil
                self.userRecord = userRecord
            }
        } else {
            print("no user record".uppercased())
            self.sync()
        }
    }
}
