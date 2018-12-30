//
//  UIButton+VerticalLayout.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/7.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

extension UIButton {
    func centerVertically(withPadding padding: CGFloat ) {
        guard self.imageView != nil else {
            return
        }
        guard self.titleLabel != nil else {
            return
        }
        
        let imageSize = self.imageView!.image?.size
        let titleSize = self.titleLabel!.text!.size(withAttributes: [.font: self.titleLabel!.font])
        
        let totalHeight = imageSize!.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize!.height),
                                            left: 0,
                                            bottom: 0,
                                            right: -titleSize.width)
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                            left: -imageSize!.width,
                                            bottom: -(totalHeight - titleSize.height),
                                            right: 0)
    }
    
    func centerVertically() {
        self.centerVertically(withPadding: 8)
    }
}
