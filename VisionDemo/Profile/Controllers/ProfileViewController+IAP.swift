//
//  File.swift
//  VisionDemo
//
//  Created by VMT on 2018/11/7.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit
import StoreKit

// FIXME: hard coded identifiers should be loaded from the server.
private let ProductIdentifiers: Set<String> = [DepositFirstCellModel.productIdentifier]

extension ProfileViewController {
    func restore() {
        // TODO: sync payments and points
        print("restore")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func buyFirstProduct() {
        print("to buy first product")
        guard let product = self.firstProductCellData.product else {
            return
        }
        // FIXME: cell reusing issue
        if let cell = self.firstProductCellData.cell, let activityIndicator = cell.accessoryView as? UIActivityIndicatorView, activityIndicator.isAnimating == false {
            activityIndicator.startAnimating()
            
            // make a payment
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    func requestProducts() {
        let productsRequest = SKProductsRequest(productIdentifiers: ProductIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
        if let cell = self.firstProductCellData.cell, let activityIndicator = cell.accessoryView as? UIActivityIndicatorView {
            activityIndicator.startAnimating()
        }
    }
}

extension ProfileViewController: SKProductsRequestDelegate {
    // load products
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        for product in products {
            print("product:", product.productIdentifier, product.localizedTitle)
            self.firstProductCellData.product = product
        }
        self.tableView.reloadData()
    }
    // payment request
    func request(_ request: SKRequest, didFailWithError error: Error) {
        self.tableView.reloadData()
    }
}
