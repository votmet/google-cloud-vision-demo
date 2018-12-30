//
//  AnalyzeHeaderView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class AnalyzeHeaderView: UIView {

    weak var imageView: UIImageView!
    weak var progressBar: ProgressBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.imageView = self.imageView(frame: CGRect.zero)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        let progressBar = ProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progressBar)
        self.progressBar = progressBar
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        self.progressBar.heightAnchor.constraint(equalToConstant: marginInner).isActive = true
        self.progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
}
