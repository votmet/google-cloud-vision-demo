//
//  TranslationTextView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/16.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

// TODO: subclass from scroll view or use scroll view as root view
class TranslationTextView: UIView {

    weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = marginInner
        
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        self.addSubview(textView)
        self.textView = textView
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let margins = self.layoutMarginsGuide
        
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.textView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.textView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
}
