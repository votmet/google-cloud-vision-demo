//
//  UITableViewCell+SubView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func labelInCell(font: UIFont, textColor: UIColor? = nil) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = font
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        return label
    }
}
