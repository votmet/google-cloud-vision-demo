//
//  ProgressBar.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class ProgressBar: UIView {

    private var bar: UIView = {
        let view = UIView()
        view.backgroundColor = primaryDarkColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var widthConstraint: NSLayoutConstraint!
    
    var progress:CGFloat? {
        didSet {
            configureProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.bar)
        self.bar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.bar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.bar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.widthConstraint = self.bar.widthAnchor.constraint(equalToConstant: 0)
        self.widthConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureProgress() {
        if let percent = self.progress {
            self.widthConstraint.isActive = false
            self.widthConstraint = self.bar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: percent)
            self.widthConstraint.isActive = true
            
            UIView.animate(withDuration: animationDefault) {
                self.layoutIfNeeded()
                if percent == 1 {
                    self.alpha = 0
                }
            }
        }
    }
    
}
