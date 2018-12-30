//
//  ViewController.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/6.
//  Copyright © 2018年 vmt. All rights reserved.
//

import UIKit
import CoreLocation

class DashboardViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var locationCoordinate: CLLocationCoordinate2D? {
        didSet {
            self.fetchWeather()
        }
    }
    var tableView: UITableView?
    var cachedURLs = [URL]()
    var weather: JSON? {
        didSet {
            if let weather = weather, let headerView = self.tableView?.tableHeaderView as? DashboardHeaderView {
                let weatherData = weather["weather"][0]
                headerView.topView.weather = Weather(weather: weatherData["main"].stringValue, temperature: (weather["main"]["temp"].floatValue * 10.0).rounded() / 10.0, icon: weatherData["icon"].stringValue)
            }
        }
    }
    var isFetchingWeather = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the view style
        self.view.backgroundColor = backgroundPrimaryColor
        
        // setup the table view
        self.tableView = self.setupTableView()
        
        self.loadWeather()
        
        self.initLocationService()
        
//        UserKit.default.sync(from: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView?.reloadData()
        if let headerView = self.tableView?.tableHeaderView as? DashboardHeaderView {
            headerView.reload()
        }
        
        if let indexPath = self.tableView?.indexPathForSelectedRow {
            self.tableView?.deselectRow(at: indexPath, animated: true)
        }
        self.navigationController?.isNavigationBarHidden = true
        
        self.fetch()
        
        self.fetchWeatherIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

}

