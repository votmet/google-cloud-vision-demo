//
//  UIView+SubView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/7.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

extension UIView {
    func button() -> UIButton {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        return button
    }
    
    func button(title: String) -> UIButton {
        let button = self.button();
        button.setTitle(title, for: .normal)
        return button
    }
    
    func button(image named: String) -> UIButton {
        let button = self.button();
        button.setImage(UIImage(named: named), for: .normal)
        return button
    }
    
    func imageView(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        return imageView
    }
    
    func label(font: UIFont, textColor:UIColor? = nil) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }
}
