//
//  Annotation.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/18.
//  Copyright © 2018年 vmt. All rights reserved.
//

import Foundation
struct Annotation {
    enum Detection: String {
        case landmark, label, web
    }
    let description: String
    var location: (latitude: Double, longitude: Double)?
    var detection: Detection
    var localized: String
    var index: Int?
}

extension Annotation {
    init?(json: [String: Any]) {
        guard let description = json["description"] as? String else {
            return nil
        }
        
        self.description = description
        self.localized = self.description
        if let localized = json["localized"] as? String {
            self.localized = localized
        }
        self.detection = .label
        
        if let locations = json["locations"] as? Array<[String: Any]> {
            if let latLng = locations[0]["latLng"] as? [String: Double] {
                self.detection = .landmark
                self.location?.latitude = latLng["latitude"] ?? 0
                self.location?.longitude = latLng["longitude"] ?? 0
            }
        }
    }
}
