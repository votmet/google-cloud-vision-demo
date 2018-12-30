//
//  DashboardViewController+Location.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/26.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit
import CoreLocation

extension DashboardViewController: CLLocationManagerDelegate {
    func initLocationService() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.locationCoordinate = location.coordinate
        }
    }
}
