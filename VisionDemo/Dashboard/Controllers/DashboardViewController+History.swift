//
//  DashboardViewController+History.swift
//  VisionDemo
//
//  Created by VMT on 2018/10/23.
//  Copyright © 2018 vmt. All rights reserved.
//

import UIKit

private let kHistoryPath = "history"
private let kHistoryImagesPath = "images"
private let kDataExtension = "plist"

// 1. save the data as `<uuid>.plist`
// 2. save the captured image as `<uuid>.jpg` in the `images` path

extension DashboardViewController {
    func historyImagesPath() -> String {
        return kHistoryImagesPath
    }
    func dataExtension() -> String {
        return kDataExtension
    }
    func fetch() {
        let fileManager = FileManager.default
        let historyURL = DashboardViewController.historyURL()
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: historyURL, includingPropertiesForKeys: [.creationDateKey])
            self.cachedURLs.removeAll()
            fileURLs.forEach { (url) in
                if url.pathExtension == kDataExtension {
                    self.cachedURLs.append(url)
//                    do {
//                        let data = try Data(contentsOf: url)
//                        let json = JSON(data)
//                        print(json)
//                    } catch {
//
//                    }
//                    do {
//                        let values = try url.resourceValues(forKeys: [.creationDateKey])
//                        print(values.creationDate!)
//                    } catch {
//
//                    }
                }
                
            }
            self.cachedURLs.sort(by: { (url1, url2) -> Bool in
                do {
                    let value1 = try url1.resourceValues(forKeys: [.creationDateKey])
                    let value2 = try url2.resourceValues(forKeys: [.creationDateKey])
                    return value1.creationDate! > value2.creationDate!
                } catch {
                    return false
                }
            })
            self.tableView?.reloadData()
        } catch {
            print("Error while enumerating files \(historyURL.path): \(error.localizedDescription)")
        }
    }
    
    class func historyURL() -> URL {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if !fileManager.fileExists(atPath: kHistoryPath) {
            do {
                try fileManager.createDirectory(at: documentsURL.appendingPathComponent("\(kHistoryPath)/\(kHistoryImagesPath)", isDirectory: true), withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
        }
        return documentsURL.appendingPathComponent(kHistoryPath, isDirectory: true)
    }
}
