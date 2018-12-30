//
//  CellModel.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/17.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

protocol CellModel {
    var title: String {get}
    var detail: String? {get}
    var style: UITableViewCell.CellStyle {get}
    var reusedIdentifier: String {get set}
    func didSelect(from viewController: UIViewController)
}

// optional variables and methods
extension CellModel {
    var detail: String? {
        get {
            return nil
        }
    }
    var style: UITableViewCell.CellStyle {
        get {
            return .default
        }
    }
    var reusedIdentifier: String {
        get {
            return "cell"
        }
        set {}
    }
    func didSelect(from viewController: UIViewController) {}
}
