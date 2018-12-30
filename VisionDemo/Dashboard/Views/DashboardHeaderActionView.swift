//
//  DashboardHeaderActionView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/7.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

class DashboardHeaderActionView: UIView {

    weak var photoLibraryButton: UIButton!
    weak var cameraButton: UIButton!
    private weak var separator: UIView!
    
    private var photosButtonTitle: String {
        return "dashboard_photos_button".localized()
    }
    
    private var cameraButtonTitle: String {
        return "dashboard_camera_button".localized()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.photoLibraryButton = self.button(title: self.photosButtonTitle, image: "icon_photos_large")
        self.cameraButton = self.button(title: self.cameraButtonTitle, image: "icon_camera_large")
        
        let separator = UIView()
        separator.backgroundColor = backgroundPrimaryColor.withAlphaComponent(0.2)
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separator)
        self.separator = separator
        
        self.setupConstraints()
    }
    
    func reload() {
        super.layoutSubviews()
        self.photoLibraryButton.setTitle(self.photosButtonTitle, for: .normal)
        self.photoLibraryButton.centerVertically()
        self.cameraButton.setTitle(self.cameraButtonTitle, for: .normal)
        self.cameraButton.centerVertically()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        self.photoLibraryButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        self.photoLibraryButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.photoLibraryButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.photoLibraryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        self.cameraButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        self.cameraButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.cameraButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.cameraButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        let margins = self.layoutMarginsGuide
        self.separator.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.separator.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.separator.widthAnchor.constraint(equalToConstant: 2).isActive = true
        self.separator.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
    }
}

extension DashboardHeaderActionView {
    private func button(title: String, image named: String) -> UIButton {
        let button = self.button(title: title.uppercased());
        button.setImage(UIImage(named: named), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.centerVertically()
        return button
    }
}
