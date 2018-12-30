//
//  LandmarkBackgroundView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class LandmarkBackgroundView: UIView {

    weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView = self.imageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.yellow
        self.addSubview(imageView)
        self.imageView = imageView
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9 / 16.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
