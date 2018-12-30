//
//  LandmarkTableViewCell.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/8.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class LandmarkTableViewCell: UITableViewCell {

    weak var keywordLabel: UILabel!
    private weak var contentBackgroundView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.init(white: 1, alpha: 0)
        
        self.keywordLabel = self.labelInCell(font: UIFont.preferredFont(forTextStyle: .headline))
        self.keywordLabel.textAlignment = .center
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        backgroundView.layer.cornerRadius = marginInner
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.05
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundView.layer.shadowRadius = 6.0
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(backgroundView, at: 0)
        self.contentBackgroundView = backgroundView
        self.backgroundView = UIView()
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentBackgroundView.backgroundColor = UIColor.white
    }
    
    private func setupConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        self.keywordLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.keywordLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.keywordLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.keywordLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        self.contentBackgroundView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.contentBackgroundView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.contentBackgroundView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.contentBackgroundView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    }
    
}
