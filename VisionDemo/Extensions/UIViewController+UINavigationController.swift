//
//  UIViewController+UINavigationController.swift
//  VisionDemo
//
//  Created by VMT on 2018/11/8.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func popToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
