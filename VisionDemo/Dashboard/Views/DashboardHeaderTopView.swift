//
//  DashboardHeaderTopView.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/7.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit

struct Weather {
    let weather: String
    let temperature: Float
    let icon: String
}

class DashboardHeaderTopView: UIView {

    private let weatherImageSize: CGFloat = 44
    private weak var weatherImageView: UIImageView!
    private weak var weatherLabel: UILabel!
    private weak var temperatureLabel: UILabel!
    
    private var isContstraintsSet = false
    
    weak var settingsButton: UIButton!
    var weather: Weather? {
        didSet {
            self.reload()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.weatherImageView = self.imageView(frame: CGRect(x: 0, y: 0, width: weatherImageSize, height: weatherImageSize))
        self.weatherImageView.image = UIImage(named: "icon_w_01d")
        
        self.weatherLabel = self.label(font: UIFont.preferredFont(forTextStyle: .headline))
        self.weatherLabel.text = "--"
        
        self.temperatureLabel = self.label(font: UIFont.preferredFont(forTextStyle: .subheadline), textColor: secondaryColor)
        self.temperatureLabel.text = "--℃"
        
        self.settingsButton = self.button(image: "icon_settings")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isContstraintsSet {
            self.setupConstraints()
        }
    }
    
    func reload() {
        if let weather = weather {
            self.weatherImageView.image = UIImage(named: "icon_w_\(weather.icon)")
            self.weatherLabel.text = weather.weather.localized()
            self.temperatureLabel.text = "\(weather.temperature)℃"
        }
    }
    
    // MARK: - Private Mehtods
    private func setupConstraints() {
        self.isContstraintsSet = true
        let margins = self.layoutMarginsGuide
        
        self.weatherImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        self.weatherImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.weatherImageView.widthAnchor.constraint(equalToConstant: weatherImageSize).isActive = true
        self.weatherImageView.heightAnchor.constraint(equalToConstant: weatherImageSize).isActive = true
        
        self.settingsButton.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        self.settingsButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.settingsButton.widthAnchor.constraint(equalToConstant: weatherImageSize).isActive = true
        self.settingsButton.heightAnchor.constraint(equalToConstant: weatherImageSize).isActive = true
        
        self.weatherLabel.topAnchor.constraint(equalTo: self.weatherImageView.topAnchor).isActive = true
        self.weatherLabel.trailingAnchor.constraint(equalTo: self.settingsButton.leadingAnchor, constant: -marginInner).isActive = true
        self.weatherLabel.leadingAnchor.constraint(equalTo: self.weatherImageView.trailingAnchor, constant: marginInner).isActive = true
        
        self.temperatureLabel.topAnchor.constraint(equalTo: self.weatherLabel.bottomAnchor).isActive = true
        self.temperatureLabel.trailingAnchor.constraint(equalTo: self.weatherLabel.trailingAnchor).isActive = true
        self.temperatureLabel.bottomAnchor.constraint(equalTo: self.weatherImageView.bottomAnchor).isActive = true
        self.temperatureLabel.leadingAnchor.constraint(equalTo: self.weatherLabel.leadingAnchor).isActive = true
        
    }
}
